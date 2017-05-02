module RubyJmeter
  class ExtendedDSL < DSL
    def jms_pointtopoint(params, &block)

        node = RubyJmeter::JmsPointtopoint.new(params).tap do |node|

          if params[:jndi_properties]
            params[:jndi_properties].map do |property_name, property_value|
              node.doc.xpath('//collectionProp').first.add_child (
               Nokogiri::XML(<<-EOS.strip_heredoc).children
                <elementProp name="#{property_name}" elementType="Argument">
                  <stringProp name="Argument.name">#{property_name}</stringProp>
                  <stringProp name="Argument.value">#{property_value}</stringProp>
                  <stringProp name="Argument.metadata">=</stringProp>
                </elementProp>
                EOS
              )
            end
          end

          attach_node(node, &block)

      end
    end
  end
end