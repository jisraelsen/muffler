Muffler [![Build Status](https://secure.travis-ci.org/jisraelsen/muffler.png?branch=master)](http://travis-ci.org/jisraelsen/muffler) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jisraelsen/muffler)
========

Flexible log suppression for Ruby. Compatible with:

 * Rails 3.x
 * Rack
 * Ruby 1.9.x

Install
-------

Just add it to your Gemfile:

```ruby
gem 'muffler'
```

Usage
-----

### Rails

Works as drop-in replacement for `Rails::Rack::Logger`.  Gemfile require
is all that's needed.

### Rack

Drop-in replacements are provided for `Rack::CommonLogger` and
`Rack::Logger`.  Just add them to your middleware stack.

```ruby
use Muffler::Rack::CommonLogger
use Muffler::Rack::Logger

run MyApp
```

### Ruby

If not using Rack or Rails you can still muffle log output by manually
calling the muffle method:

```ruby
logger = Logger.new('app.log')

Muffler.muffle(logger) do
  # your custom code here
end
```

You can still take advantage of conditional muffling as well:

```ruby
logger = Logger.new('app.log')

if Muffler.muffle?('REMOTE_ADDR' => '127.0.0.1')
  Muffler.muffle(logger) do
    # muffled code here
  end
else
  # unmuffled code
end
```

By default, Muffler muffles log output based on the request environment.
It does comparisons against `REMOTE_ADDR`, `PATH_INFO`, and a custom
header you can configure.  The default header looked for is: 
`HTTP_X_MUFFLE_LOGGER`.

Note that when sending the abover header in the request it should be
named `X-Muffle-Logger` or `X-MUFFLE-LOGGER`.

You can configure which IP addresses, request paths, and headers to look
for:

```ruby
Muffler.configure do |config|
  config.ips += ['10.1.1.3', '10.1.1.4']
  config.paths << %r{/assets}
  config.header = 'HTTP_X_MY_CUSTOM_HEADER'
end
```

You can also add your own "mufflers" or replace the defaults.  Custom
mufflers just need to return true (muffle log output) or false (don't
muffle log output).

If still using Rack or Rails, you could add a params muffler:

```ruby
Muffler.configure do |config|
  config.muffle_with :params do |env|
    request = Rack::Request.new(env)
    request.params['muffle'].to_i == 1
  end
end
```

Of if just working with Ruby you could clear the default filters and add
your own:

```ruby
Muffler.configure do |config|
  config.mufflers.clear # clear default mufflers
  config.muffle_with :random do |opts|
    [true, false].sample
  end
end
```

The default mufflers are:

  * `:header`
  * `:ip`
  * `:path`

Contributing
------------

Pull requests are welcome.  Just make sure to include tests!

To run tests, install some dependencies:

```bash
bundle install
```

Then, run tests with:

```bash
rake test
```

Or, If you want to check coverage:

```bash
COVERAGE=true rake test
```

Issues
------

Please use GitHub's [issue tracker](http://github.com/jisraelsen/muffler/issues).

Author
------

[Jeremy Israelsen](http://github.com/jisraelsen)

