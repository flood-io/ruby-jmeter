module RubyJmeter
  class ExtendedDSL < DSL
    def foreach_controller(params = {}, &block)
      node = RubyJmeter::ForeachController.new(params).tap do |node|
        if params[:start_index]
          params[:startIndex] = params[:start_index]
          node.doc.children.first.add_child (
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="ForeachController.startIndex"/>
            EOS
          )
        end

        if params[:end_index]
          params[:endIndex] = params[:end_index]
          node.doc.children.first.add_child (
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="ForeachController.endIndex"/>
            EOS
          )
        end
      end

      attach_node(node, &block)
    end
  end
end
