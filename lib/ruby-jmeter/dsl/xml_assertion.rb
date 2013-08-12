module RubyJmeter
  class DSL
    def xml_assertion(params={}, &block)
      node = RubyJmeter::XmlAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class XmlAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'XmlAssertion' : (params[:name] || 'XmlAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{testname}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
