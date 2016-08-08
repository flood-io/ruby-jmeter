module RubyJmeter
  class ExtendedDSL < DSL
    def throughput_controller(params = {}, &block)
      params[:style] = 1 if params[:percent]
      params[:maxThroughput] = params[:total] || params[:percent] || 1

      node = RubyJmeter::ThroughputController.new(params)
      node.doc.xpath(".//FloatProperty/value").first.content = params[:maxThroughput].to_f

      attach_node(node, &block)
    end

    alias throughput throughput_controller
  end
end
