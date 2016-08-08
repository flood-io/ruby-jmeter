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
      enabled_disabled(params)
      if params.class == Array
        update_collection params
      else
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          if value.class == Nokogiri::XML::Builder
            node.first.children = value.doc.at_xpath('//builder').children
          else
            node.first.content = value unless node.empty?
          end

        end
      end
    end

    def enabled_disabled(params)
      return unless params.is_a?(Hash)
      @doc.children.first.attributes['enabled'].value = params[:enabled].to_s.empty? ? 'true' : 'false'
    end

    def update_at_xpath(params)
      params[:update_at_xpath].each do |fragment|
        if fragment[:xpath]
          @doc.at_xpath(fragment[:xpath]) << fragment[:value]
        else
          fragment.each do |xpath, value|
            @doc.at_xpath(xpath).content = value
          end
        end
      end
    end

    def update_collection(params)
      elements = @doc.at_xpath("//collectionProp/elementProp")
      params.each_with_index do |param, index|
        param.each do |name, value|
          next unless elements && elements.element_children
          element = elements.element_children.xpath("//*[contains(@name,\"#{name}\")]")
          element.last.content = value
        end
        if index != params.size - 1 && elements
           @doc.at_xpath("//collectionProp") << elements.dup
        end
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
