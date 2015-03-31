#--
# Copyright (c) 2012 Wang Yongzhi
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'rest_client'

module OpenTaobao
  REQUEST_TIMEOUT = 10
  API_VERSION = '2.0'
  USER_AGENT = "open_taobao-v#{VERSION}"

  class Error < StandardError; end

  class << self
    attr_accessor :config, :session

    @@attr_map = {
      'taobao.item.add' => {
      'required' => Set.new(['num', 'price', 'type', 'stuff_status', 'title', 'desc',
                            'cid', 'location.state', 'location.city']),
                            'optional' => Set.new(['outer_id', 'locality_life.choose_logis', 'locality_life.merchant',
                                                  'locality_life.expirydate', 'image'])
    }
    }

    # Load a yml config, and initialize http session
    # yml config file content should be:
    #
    #   app_key:    "YOUR APP KEY"
    #   secret_key: "YOUR SECRET KEY"
    #   endpoint:   "TAOBAO GATEWAY API URL"
    #
    def init_config(app_key, secret, session, endpoint, tmp_file_path = '/tmp/')
      @config = {
        'app_key' => app_key,
        'secret' => secret,
        'session' => session,
        'endpoint' => endpoint,
        'tmp_file_path' => tmp_file_path
      }
    end

    # check config
    #
    # raise exception if config key missed in YAML file
    def check_config
      list = []
      %w(app_key secret endpoint).map do |k|
        list << k unless @config.has_key? k
      end

      raise "[#{list.join(', ')}] not included in your yaml file." unless list.empty?
    end

    # Return request signature with MD5 signature method
    def sign(params)
      Digest::MD5::hexdigest(wrap_with_secret sorted_option_string(params)).upcase
    end

    # wrapped with secret_key
    def wrap_with_secret(s)
      ret = "#{@config['secret']}#{s}#{@config['secret']}"
      puts "ret = [%s]" % ret
      ret
    end

    # Return sorted request parameter by request key
    def sorted_option_string(options)
      options.map {|k, v| "#{k}#{v}" }.sort.join
    end

    # Merge custom parameters with TAOBAO system parameters.
    #
    # System paramters below will be merged. 
    #
    #   timestamp
    #   v
    #   format
    #   sign_method
    #   app_key
    #
    # Current Taobao API Version is '2.0'.
    # <tt>format</tt> should be json.
    # Only <tt>sign_method</tt> MD5 is supported so far.
    def full_options(params)
      {
        :timestamp   => Time.now.strftime("%F %T"),
        :v           => API_VERSION,
        :format      => :json,
        :sign_method => :md5,
        :app_key     => config['app_key']
      }.merge params
    end

    def query_hash(params)
      params = full_options params
      params[:sign] = sign params
      params
    end

    # Retrun query string with signature.
    def query_string(params)
      "?" + query_hash(params).to_query
    end

    # Return full url with signature.
    def url(params)
      "%s%s" % [@config['endpoint'], query_string(params)]
    end

    # Return a parsed JSON object.
    def parse_result(data)
      MultiJson.decode(data)
    end

    # Request by get method and return result in JSON format
    def get(params)
      path = query_string(params)
      parse_result session.get(path).body
    end

    # Request by get method and return result in JSON format
    # Raise OpenTaobao::Error if returned with error_response
    def get!(params)
      response = get params
      raise Error.new(MultiJson.encode response['error_response']) if response.has_key?('error_response')
      response
    end

    # Request by post method and return result in JSON format
    def post(params)
      parse_result session.post('', query_hash(params).to_query).body
    end

    # Request by post method and return result in JSON format
    # Raise OpenTaobao::Error if returned with error_response
    def post!(params)
      response = post params
      raise Error.new(MultiJson.encode response['error_response']) if response.has_key?('error_response')
      response
    end

    def item_add(params)
      puts "config is #{@config}"
      item_add_params = special_params('taobao.item.add', params)
      final_params = item_add_params.merge common_params('taobao.item.add') if nil != item_add_params
      if params.has_key?('image')
        image = final_params['image']
        final_params.delete('image')
      else
        image = nil
      end
      full_url = prepare_url(final_params) 
      if nil == image
        response = RestClient.get(full_url)
      else
        filename = random_file_name(final_params)
        response = RestClient.post(full_url, {
          :upload => {image: prepare_file(filename, image)}
        })
        File.delete(filename)
      end
      puts response.body
    end

    def common_params(method)
      {
        'app_key' => @config['app_key'],
        'secret' => @config['secret'],
        'session' => @config['session'],
        'format' => 'json',
        'v' => API_VERSION,
        'sign_method' => 'md5',
        'timestamp' => (Time.now.to_f * 1000).to_i.to_s,
        'method' => method,
      }
    end

    def special_params(method, input_params)
      required_params = {}
      @@attr_map[method]['required'].each do |para|
        if input_params.has_key?(para)
          required_params[para] = input_params[para]
        else
          puts "Miss #{para}"
          return nil
        end
      end
      optional_params = {}
      @@attr_map[method]['optional'].each do |para|
        optional_params[para] = input_params[para] if input_params.has_key?(para)
      end
      return required_params.merge optional_params
    end

    def prepare_url(final_params)
      final_params['sign'] = sign(final_params)
      query = final_params.map {|k, v| "#{k}=#{v}"}.join('&')
      full_url = "#{config['endpoint']}?#{URI.escape(query)}"
    end

    def prepare_file(filename, content)
      f = File.open(filename, "wb")
      f.write(content)
      f.close
      File.new(filename, "rb")
    end

    def random_file_name(final_params)
        "%s_%s_%d" % [final_params['timestamp'], final_params['method'], rand(10000)]
    end



  end
end
