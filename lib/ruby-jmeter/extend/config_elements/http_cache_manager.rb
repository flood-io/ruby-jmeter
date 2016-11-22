module RubyJmeter
  class ExtendedDSL < DSL
    def http_cache_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration
      params[:useExpires] = true if params.keys.include? :use_expires

      super
    end

    alias cache http_cache_manager
  end
end
