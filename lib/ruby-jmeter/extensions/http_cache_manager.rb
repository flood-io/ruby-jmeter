module RubyJmeter
  class ExtendedDSL < DSL
    def http_cache_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration

      super
    end

    alias cache http_cache_manager
  end
end
