module RubyJmeter
  class ExtendedDSL < DSL
    def http_cookie_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration

      super
    end

    alias cookies http_cookie_manager
  end
end
