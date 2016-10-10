module RubyJmeter
  class ExtendedDSL < DSL
    def constant_throughput_timer(params, &block)
      params[:value] ||= params[:throughput] || 0.0

      node = RubyJmeter::ConstantThroughputTimer.new(params)
      node.doc.xpath('//stringProp[@name="throughput"]').first.content = params[:value]
      attach_node(node, &block)
    end
  end
end
