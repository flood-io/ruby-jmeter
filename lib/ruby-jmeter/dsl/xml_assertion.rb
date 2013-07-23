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
      params[:name] ||= 'XmlAssertion'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
