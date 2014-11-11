module RubyJmeter
  class DSL
    def http_url_rewriting_modifier(params={}, &block)
      node = RubyJmeter::HttpUrlRewritingModifier.new(params)
      attach_node(node, &block)
    end
  end

  class HttpUrlRewritingModifier
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'HttpUrlRewritingModifier' : (params[:name] || 'HttpUrlRewritingModifier')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<URLRewritingModifier guiclass="URLRewritingModifierGui" testclass="URLRewritingModifier" testname="#{testname}" enabled="true">
  <stringProp name="argument_name"/>
  <boolProp name="path_extension">false</boolProp>
  <boolProp name="path_extension_no_equals">false</boolProp>
  <boolProp name="path_extension_no_questionmark">false</boolProp>
  <boolProp name="cache_value">false</boolProp>
  <boolProp name="encode">false</boolProp>
</URLRewritingModifier>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
