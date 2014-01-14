module RubyJmeter
  class DSL
    def user_defined_variables(params={}, &block)
      node = RubyJmeter::UserDefinedVariables.new(params)
      attach_node(node, &block)
    end
  end

  class UserDefinedVariables
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'UserDefinedVariables' : (params[:name] || 'UserDefinedVariables')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
  <collectionProp name="Arguments.arguments">
    <elementProp name=" " elementType="Argument">
      <stringProp name="Argument.name"> </stringProp>
      <stringProp name="Argument.value"> </stringProp>
      <stringProp name="Argument.metadata">=</stringProp>
      <stringProp name="Argument.desc"> </stringProp>
    </elementProp>
  </collectionProp>
  <stringProp name="TestPlan.comments"> </stringProp>
</Arguments>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
