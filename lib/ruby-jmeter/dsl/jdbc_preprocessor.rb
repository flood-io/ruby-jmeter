module RubyJmeter
  class DSL
    def jdbc_preprocessor(params={}, &block)
      node = RubyJmeter::JdbcPreprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class JdbcPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JdbcPreprocessor' : (params[:name] || 'JdbcPreprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCPreProcessor guiclass="TestBeanGUI" testclass="JDBCPreProcessor" testname="#{testname}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
  <stringProp name="queryTimeout"/>
  <stringProp name="resultSetHandler">Store as String</stringProp>
</JDBCPreProcessor>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
