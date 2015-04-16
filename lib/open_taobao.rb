require 'digest'
require 'faraday'
require 'multi_json'
require 'yaml'
require 'rest_client'

require 'open_taobao/version'
require 'open_taobao/open_taobao'
require 'open_taobao/parameters'

require 'open_taobao/railtie' if defined? Rails
