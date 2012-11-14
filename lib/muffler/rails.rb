require 'muffler/rails/logger'

module Muffler
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'muffler.middleware' do |app|
        app.config.middleware.swap ::Rails::Rack::Logger, Muffler::Rails::Logger, app.config.log_tags
      end
    end
  end
end
