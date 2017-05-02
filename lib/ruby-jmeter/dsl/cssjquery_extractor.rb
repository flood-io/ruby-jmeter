module RubyJmeter
  class DSL
    def cssjquery_extractor(params={}, &block)
      node = RubyJmeter::CssjqueryExtractor.new(params)
      attach_node(node, &block)
    end
  end

  class CssjqueryExtractor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'CssjqueryExtractor' : (params[:name] || 'CssjqueryExtractor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HtmlExtractor guiclass="HtmlExtractorGui" testclass="HtmlExtractor" testname="#{testname}" enabled="true">
  <stringProp name="HtmlExtractor.refname"/>
  <stringProp name="HtmlExtractor.expr"/>
  <stringProp name="HtmlExtractor.attribute"/>
  <stringProp name="HtmlExtractor.default"/>
  <stringProp name="HtmlExtractor.match_number"/>
  <stringProp name="HtmlExtractor.extractor_impl"/>
  <boolProp name="HtmlExtractor.default_empty_value"/>
</HtmlExtractor>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
