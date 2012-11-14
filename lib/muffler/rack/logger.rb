module Muffler
  module Rack
    class Logger < ::Rack::Logger
      def call(env)
        logger = ::Logger.new(env['rack.errors'])
        logger.level = @level

        env['rack.logger'] = logger

        if Muffler.muffle?(env)
          Muffler.muffle(logger) { @app.call(env) }
        else
          @app.call(env)
        end
      end
    end
  end
end
