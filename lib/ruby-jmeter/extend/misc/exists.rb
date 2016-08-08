module RubyJmeter
  class ExtendedDSL < DSL
    def exists(variable, &block)
      params ||= {}
      params[:condition] = "\"${#{variable}}\" != \"\\${#{variable}}\""
      params[:useExpression] = false
      params[:name] = "if ${#{variable}}"
      node = RubyJmeter::IfController.new(params)

      attach_node(node, &block)
    end
  end
end
