module RubyJmeter
  class DSL
    def jdbc_connection_configuration(params={}, &block)
      node = RubyJmeter::JdbcConnectionConfiguration.new(params)
      attach_node(node, &block)
    end
  end

  class JdbcConnectionConfiguration
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JdbcConnectionConfiguration' : (params[:name] || 'JdbcConnectionConfiguration')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCDataSource guiclass="TestBeanGUI" testclass="JDBCDataSource" testname="#{testname}" enabled="true">
  <boolProp name="autocommit">true</boolProp>
  <stringProp name="checkQuery">Select 1</stringProp>
  <stringProp name="connectionAge">5000</stringProp>
  <stringProp name="dataSource"/>
  <stringProp name="dbUrl"/>
  <stringProp name="driver"/>
  <boolProp name="keepAlive">true</boolProp>
  <stringProp name="password"/>
  <stringProp name="poolMax">10</stringProp>
  <stringProp name="timeout">10000</stringProp>
  <stringProp name="transactionIsolation">DEFAULT</stringProp>
  <stringProp name="trimInterval">60000</stringProp>
  <stringProp name="username"/>
</JDBCDataSource>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
