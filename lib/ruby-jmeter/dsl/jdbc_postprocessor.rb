module RubyJmeter
  class DSL
    def jdbc_postprocessor(params={}, &block)
      node = RubyJmeter::JdbcPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class JdbcPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JdbcPostprocessor' : (params[:name] || 'JdbcPostprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCPostProcessor guiclass="TestBeanGUI" testclass="JDBCPostProcessor" testname="#{testname}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
  <stringProp name="queryTimeout"/>
  <stringProp name="resultSetHandler">Store as String</stringProp>
</JDBCPostProcessor>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
