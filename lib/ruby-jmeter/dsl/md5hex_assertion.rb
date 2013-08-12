module RubyJmeter
  class DSL
    def md5hex_assertion(params={}, &block)
      node = RubyJmeter::Md5hexAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class Md5hexAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Md5hexAssertion' : (params[:name] || 'Md5hexAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<MD5HexAssertion guiclass="MD5HexAssertionGUI" testclass="MD5HexAssertion" testname="#{testname}" enabled="true">
  <stringProp name="MD5HexAssertion.size"/>
</MD5HexAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
