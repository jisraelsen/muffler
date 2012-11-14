require 'spec_helper'

module Muffler
  describe Config do
    describe '#initialize' do
      it 'initializes defaults' do
        config = Config.new
        config.header.must_equal 'HTTP_X_MUFFLE_LOGGER'
        config.ips.must_equal []
        config.paths.must_equal []
      end

      it 'adds default mufflers' do
        muffle_opts = {
          'HTTP_X_MUFFLE_LOGGER' => '1',
          'REMOTE_ADDR' => '127.0.0.1',
          'PATH_INFO' => '/login'
           
        }
        dont_muffle_opts = {
          'REMOTE_ADDR' => '10.1.1.3',
          'PATH_INFO' => '/assets'
        }

        config = Config.new
        config.ips << '127.0.0.1'
        config.paths << '/login'

        config.mufflers[:header].call(muffle_opts).must_equal true
        config.mufflers[:ip].call(muffle_opts).must_equal true
        config.mufflers[:path].call(muffle_opts).must_equal true

        config.mufflers[:header].call(dont_muffle_opts).must_equal false
        config.mufflers[:ip].call(dont_muffle_opts).must_equal false
        config.mufflers[:path].call(dont_muffle_opts).must_equal false
      end
    end

    describe '#muffle_with' do
      it 'adds new muffler to mufflers hash' do
        config = Config.new
        config.mufflers.wont_include :test

        config.muffle_with :test do |opts|
          'this is a test'
        end

        config.mufflers.must_include :test
        config.mufflers[:test].call({}).must_equal 'this is a test'
      end

      it 'replaces an existing muffler in the mufflers hash' do
        config = Config.new
        config.muffle_with :test do |opts|
          'this is a test'
        end

        config.mufflers[:test].call({}).must_equal 'this is a test'

        config.muffle_with :test do |opts|
          'this is another test'
        end

        config.mufflers[:test].call({}).must_equal 'this is another test'
      end
    end
  end
end
