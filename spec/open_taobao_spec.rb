# encoding: utf-8
require 'spec_helper'
require 'tempfile'
describe OpenTaobao do
 ENDPOINT = "http://gw.api.tbsandbox.com/router/rest"

  before(:each) do
    # @now = Time.parse('2012-10-29 23:30')
    # Time.stub(:now) { @now }
=begin
    config = YAML.load(File.open("./secret.yaml"))
    puts "config is #{config}"
    OpenTaobao.init_config(app_key: config['app_key'], secret: config['secret'], session: config['session'], endpoint: config['endpoint'], parameter_config_file: "./config.yaml")
=end
    OpenTaobao.init_config('./secret.yaml', './config.yaml')
  end

  # we only need to load config file here once for all test
  it "should load config file" do
    OpenTaobao.config.should == {
      'app_key'    => 'test',
      'secret_key' => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }
  end

  it "should raise exception if config yaml does not include correct keys" do
    OpenTaobao.config = {
      'secret_key' => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }

    expect {
      OpenTaobao.check_config
    }.to raise_error('[app_key] not included in your yaml file.')
  end

  it "should merge with default options" do
    options = {:foo => 'foo', :bar => 'bar'}
    OpenTaobao.full_options(options).should ==
    {
      :foo         => 'foo',
      :bar         => 'bar',
      :timestamp   => @now.strftime("%F %T"),
      :v           => '2.0',
      :format      => :json,
      :sign_method => :md5,
      :app_key     => 'test'
    }
  end

  # ref: http://open.taobao.com/doc/detail.htm?spm=0.0.0.30.iamImZ&id=111
  it "should return sorted options string" do
    options = {
      'timestamp'  => '2011-07-01 13:52:03',
      'v'          => '2.0',
      'app_key'    => 'test',
      'method'     => 'taobao.user.get',
      'sign_method'     => 'md5',
      'format'     => 'xml',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.sorted_option_string(options).should == "app_keytestfieldsnick,location.state,location.cityformatxmlmethodtaobao.user.getnick商家测试帐号17sign_methodmd5timestamp2011-07-01 13:52:03v2.0"
  end

  # ref: http://open.taobao.com/doc/detail.htm?spm=0.0.0.30.iamImZ&id=111
  it "should return signature" do
    options = {
      'timestamp'  => '2011-07-01 13:52:03',
      'v'          => '2.0',
      'app_key'    => 'test',
      'method'     => 'taobao.user.get',
      'sign_method'     => 'md5',
      'format'     => 'xml',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.sign(options).should == '5029C3055D51555112B60B33000122D5'
  end

  it "should return query string for url" do
    options = {
      :timestamp  => '2011-07-01 13:52:03',
      :method     => 'taobao.user.get',
      :format     => 'xml',
      :partner_id => 'top-apitools',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.query_string(options).should include("sign=")
    OpenTaobao.query_string(options).should include("timestamp=")
    OpenTaobao.query_string(options).should include("method=taobao.user.get")
    OpenTaobao.query_string(options).should include("format=xml")
    OpenTaobao.query_string(options).should include("partner_id=top-apitools")
  end

  it "item_add_request" do
    params = {
      'num' => 10,
      'price' => 0.05,
      'type' => 'fixed',
      'stuff_status' => 'new',
      'title' => 'Can',
      'desc' => "Come on baby, tttt",
      'cid' => '123606001',
      'outer_id' => '12345',
      'locality_life.choose_logis' => 1,
      'locality_life.merchant' => "2056231041:有演出",
      'locality_life.expirydate'  => "2015-11-11",
      'location.state' => '广东',
      'location.city' => '佛山',
      'image' => File.open("1.pic.jpg", "r").read
    }
    response = OpenTaobao.item_add(params)
    puts response
  end

  it "item_sku_add_request" do
    params = {
      'num_iid' => '44487662987',
      "properties" => "$票种:DDC",
      "quantity" => 10,
      "price" => 0.09,
      "outer_id" => "7777",
      "lang" => "zh_CN",
    }
    response = OpenTaobao.item_sku_add(params)
    puts response
  end

=begin
  it "vmarket_eticket_consume" do
    params = {
      'order_id' = 
    }
  end
=end

  it "vmarket_eticket_qrcode_upload" do
    params = {
      'img_bytes' => File.open("ff.png", "r").read,
      'code_merchant_id' => '2056231041',
    }
    j = OpenTaobao.vmarket_eticket_qrcode_upload(params)
    puts j
  end

  it "vmarket_eticket_send" do
    params = {
      'order_id' => '922705003187153',
      'verify_codes' => '111:1',
      'token' => '8e11b544627bbf7e6ad82ff888287625',
      'codemerchant_id' => '2056231041',
      'qr_images' => 'TB143XdHFXXXXb.XVXXXXXXXXXX.png"',
    }
    j = OpenTaobao.request('taobao.vmarket.eticket.send', params)
    puts j
  end

  it "vmarket_eticket_consume" do
    params = {
      'order_id' => '922705003187153',
      'verify_code' => '111',
      'consume_num' => '1',
      'token' => '8e11b544627bbf7e6ad82ff888287625',
    }
    j = OpenTaobao.request('taobao.vmarket.eticket.consume', params)
    puts j
  end

end
 
