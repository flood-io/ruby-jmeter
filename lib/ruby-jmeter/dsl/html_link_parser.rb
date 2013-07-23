module RubyJmeter
  class DSL
    def html_link_parser(params={}, &block)
      node = RubyJmeter::HtmlLinkParser.new(params)
      attach_node(node, &block)
    end
  end

  class HtmlLinkParser
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'HtmlLinkParser'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AnchorModifier guiclass="AnchorModifierGui" testclass="AnchorModifier" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
