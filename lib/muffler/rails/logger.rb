require 'rails/rack/logger'

module Muffler
  module Rails
    class Logger < ::Rails::Rack::Logger
      def call(env)
        if Muffler.muffle?(env)
          Muffler.muffle(::Rails.logger) { super }
        else
          super
        end
      end
    end
  end
end
