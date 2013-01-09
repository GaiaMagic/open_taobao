# OpenTaobao

Taobao Open Platform client for ruby. Rails3 is supported.

## Installation

Add this line to your application's Gemfile:

    gem 'open_taobao'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_taobao

Run generate to complete install:

    $ rails g open_taobao:install

在你的`Rails`项目的`config`目录下会生成一个`taobao.yml`文件,
打开taobao.yml文件，设置你自己的`app_key`, `secret_key`, 淘宝客的`pid`

## Usage

### Rails with yaml file configured

调用`OpenTaobao.get`方法，传入相应参数：

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

返回内容将自动转化为hash格式。

### plain ruby

    OpenTaobao.config = {
      'app_key'    => 'test',
      'secret_key' => 'test',
      'pid'        => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }

    OpenTaobao.initialize_session
    OpenTaobao.timeout = 50 # change http timeoute, default is 10 seconds.

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
