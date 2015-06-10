module RubyJmeter
  module Plugins
    class BasePlugin
      attr_accessor :filename
      def initialize(params={})
        @filename = "#{Dir.pwd}/#{params[:filename]}" if params[:filename]
      end
    end
  end
end
