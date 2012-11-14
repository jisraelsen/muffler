module Muffler
  class Config
    attr_accessor :header, :ips, :paths, :mufflers

    def initialize
      @header = 'HTTP_X_MUFFLE_LOGGER' # send in header as X-Muffle-Logger
      @ips = []
      @paths = []
      @mufflers = {}

      muffle_with(:header) { |opts| !opts[@header].nil? }
      muffle_with(:ip)     { |opts| @ips.any? { |ip| ip === opts['REMOTE_ADDR'] } }
      muffle_with(:path)   { |opts| @paths.any? { |path| path === opts['PATH_INFO'] } }
    end

    def muffle_with(name, &block)
      @mufflers[name] = block
    end
  end
end
