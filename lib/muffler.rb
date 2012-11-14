require 'logger'
require 'muffler/config'
require 'muffler/version'

if defined?(Rails)
  require 'muffler/rails'
elsif defined?(Rack)
  require 'muffler/rack'
end

module Muffler
  class << self
    def muffle?(opts={})
      config.mufflers.values.any? { |m| m.call(opts) }
    end

    def muffle(logger, level=Logger::ERROR)
      original_level = logger.level
      logger.level = level

      yield
    ensure
      logger.level = original_level
    end

    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end
