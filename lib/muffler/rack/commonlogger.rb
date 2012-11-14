module Muffler
  module Rack
    class CommonLogger < ::Rack::CommonLogger
      private
      def log(env, status, header, began_at)
        super unless Muffler.muffle?(env)
      end
    end
  end
end
