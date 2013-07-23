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
      params[:name] ||= 'CssjqueryExtractor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HtmlExtractor guiclass="HtmlExtractorGui" testclass="HtmlExtractor" testname="#{params[:name]}" enabled="true">
  <stringProp name="HtmlExtractor.refname"/>
  <stringProp name="HtmlExtractor.expr"/>
  <stringProp name="HtmlExtractor.attribute"/>
  <stringProp name="HtmlExtractor.default"/>
  <stringProp name="HtmlExtractor.match_number"/>
  <stringProp name="HtmlExtractor.extractor_impl"/>
</HtmlExtractor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
