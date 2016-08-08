module RubyJmeter
  class ExtendedDSL < DSL
    def random_timer(delay=0, range=0, &block)
      params = {}
      params[:delay] = delay
      params[:range] = range
      node = RubyJmeter::GaussianRandomTimer.new(params)

      attach_node(node, &block)
    end

    alias think_time random_timer
  end
end
