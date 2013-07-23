module RubyJmeter
  class DSL
    def csv_data_set_config(params={}, &block)
      node = RubyJmeter::CsvDataSetConfig.new(params)
      attach_node(node, &block)
    end
  end

  class CsvDataSetConfig
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'CsvDataSetConfig'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CSVDataSet guiclass="TestBeanGUI" testclass="CSVDataSet" testname="#{params[:name]}" enabled="true">
  <stringProp name="delimiter">,</stringProp>
  <stringProp name="fileEncoding"/>
  <stringProp name="filename"/>
  <boolProp name="quotedData">false</boolProp>
  <boolProp name="recycle">true</boolProp>
  <stringProp name="shareMode">All threads</stringProp>
  <boolProp name="stopThread">false</boolProp>
  <stringProp name="variableNames"/>
</CSVDataSet>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
