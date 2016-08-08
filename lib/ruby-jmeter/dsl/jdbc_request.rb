module RubyJmeter
  class DSL
    def jdbc_request(params={}, &block)
      node = RubyJmeter::JdbcRequest.new(params)
      attach_node(node, &block)
    end
  end

  class JdbcRequest
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JdbcRequest' : (params[:name] || 'JdbcRequest')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCSampler guiclass="TestBeanGUI" testclass="JDBCSampler" testname="#{testname}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
  <stringProp name="queryTimeout"/>
  <stringProp name="resultSetHandler">Store as String</stringProp>
</JDBCSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
