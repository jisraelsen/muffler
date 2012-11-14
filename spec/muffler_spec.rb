require 'spec_helper'

describe Muffler do
  describe '.muffle?' do
    before do
      Muffler.configure do |config|
        config.ips << '127.0.0.1'
        config.paths << '/assets'
      end
    end

    it 'returns true if any mufflers return true' do
      Muffler.muffle?('REMOTE_ADDR' => '127.0.0.1', 'PATH_INFO' => '/login').must_equal true
    end

    it 'returns false if all mufflers return false' do
      Muffler.muffle?('REMOTE_ADDR' => '10.1.1.3', 'PATH_INFO' => '/login').must_equal false
    end
  end

  describe '.muffle' do
    before do
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    describe 'with a provided log level' do
      it 'changes log level to provided level in block' do
        Muffler.muffle(@logger, Logger::WARN) do
          @logger.level.must_equal Logger::WARN
        end
      end
    end

    describe 'with no provided log level' do
      it 'changes log level to Logger::ERROR in block' do
        Muffler.muffle(@logger) do
          @logger.level.must_equal Logger::ERROR
        end
      end
    end

    it 'reverts log level back to original level after block' do
      Muffler.muffle(@logger) {}
      @logger.level.must_equal Logger::INFO
    end
  end

  describe '.configure' do
    it 'yields the config to a block' do
      Muffler.configure do |config|
        config.must_equal Muffler.config
      end
    end
  end

  describe '.config' do
    it 'returns the Muffle config object' do
      Muffler.config.must_be_instance_of Muffler::Config
    end

    it 'memoizes the config object' do
      Muffler.config.object_id.must_equal Muffler.config.object_id
    end
  end
end
