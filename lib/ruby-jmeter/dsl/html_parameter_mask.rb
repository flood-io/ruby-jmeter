module RubyJmeter
  class DSL
    def html_parameter_mask(params={}, &block)
      node = RubyJmeter::HtmlParameterMask.new(params)
      attach_node(node, &block)
    end
  end

  class HtmlParameterMask
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'HtmlParameterMask'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ParamModifier guiclass="ParamModifierGui" testclass="ParamModifier" testname="#{params[:name]}" enabled="true">
  <elementProp name="ParamModifier.mask" elementType="ParamMask">
    <stringProp name="ParamModifier.field_name"/>
    <stringProp name="ParamModifier.prefix"/>
    <longProp name="ParamModifier.lower_bound">0</longProp>
    <longProp name="ParamModifier.upper_bound">10</longProp>
    <longProp name="ParamModifier.increment">1</longProp>
    <stringProp name="ParamModifier.suffix"/>
  </elementProp>
</ParamModifier>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
