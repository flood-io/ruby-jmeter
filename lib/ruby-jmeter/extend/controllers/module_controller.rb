module RubyJmeter
  class ExtendedDSL < DSL
    def module_controller(params, &block)
      node = RubyJmeter::ModuleController.new(params)

      if params[:test_fragment]
        params[:test_fragment].kind_of?(String) &&
        params[:test_fragment].split('/')
      elsif params[:node_path]
        params[:node_path]
      else
        []
      end.each_with_index do |node_name, index|
        node.doc.at_xpath('//collectionProp') <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="node_#{index}">#{node_name}</stringProp>
          EOS
      end

      attach_node(node, &block)
    end
  end
end
