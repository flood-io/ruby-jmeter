module RubyJmeter
  class ExtendedDSL < DSL
    def loop_controller(params, &block)
      params[:loops] = params[:count] || 1

      super
    end

    alias loops loop_controller
  end
end
