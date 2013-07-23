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
      params[:name] ||= 'JdbcRequest'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCSampler guiclass="TestBeanGUI" testclass="JDBCSampler" testname="#{params[:name]}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
</JDBCSampler>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
