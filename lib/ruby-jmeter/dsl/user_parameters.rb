module RubyJmeter
  class DSL
    def user_parameters(params={}, &block)
      node = RubyJmeter::UserParameters.new(params)
      attach_node(node, &block)
    end
  end

  class UserParameters
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'UserParameters' : (params[:name] || 'UserParameters')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<UserParameters guiclass="UserParametersGui" testclass="UserParameters" testname="#{testname}" enabled="true">
  <collectionProp name="UserParameters.names"/>
  <collectionProp name="UserParameters.thread_values">
    <collectionProp name="1"/>
    <collectionProp name="1"/>
  </collectionProp>
  <boolProp name="UserParameters.per_iteration">false</boolProp>
</UserParameters>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
