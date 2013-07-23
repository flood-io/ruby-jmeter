module RubyJmeter

  def dsl_eval(dsl, &block)
    block_context = eval("self", block.binding)
    proxy_context = RubyJmeter::FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each { |ivar| proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar)) }
      proxy_context.instance_eval(&block)
    ensure
      block_context.instance_variables.each { |ivar| block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar)) }
    end
    dsl
  end

  module_function :dsl_eval

  module Helper
    def update(params)
      params.delete(:name)
      params.each do |name, value|
        node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
        node.first.content = value unless node.empty?
      end
    end

    def update_at_xpath(params)
      params[:update_at_xpath].each do |fragment|
        @doc.at_xpath(fragment[:xpath]) << fragment[:value]
      end
    end

    def enabled(params)
      #default to true unless explicitly set to false
      if params.has_key?(:enabled) && params[:enabled] == false
        'false'
      else
        'true'
      end
    end
  end
end
