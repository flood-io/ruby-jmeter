module RubyJmeter
  class DSL
    def regular_expression_extractor(params={}, &block)
      node = RubyJmeter::RegularExpressionExtractor.new(params)
      attach_node(node, &block)
    end
  end

  class RegularExpressionExtractor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'RegularExpressionExtractor' : (params[:name] || 'RegularExpressionExtractor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="#{testname}" enabled="true">
  <stringProp name="RegexExtractor.useHeaders">false</stringProp>
  <stringProp name="RegexExtractor.refname"/>
  <stringProp name="RegexExtractor.regex"/>
  <stringProp name="RegexExtractor.template"/>
  <stringProp name="RegexExtractor.default"/>
  <stringProp name="RegexExtractor.match_number"/>
  <stringProp name="Sample.scope">all</stringProp>
  <boolProp name="RegexExtractor.default_empty_value"/>
</RegexExtractor>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
