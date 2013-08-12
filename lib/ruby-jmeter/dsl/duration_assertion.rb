module RubyJmeter
  class DSL
    def duration_assertion(params={}, &block)
      node = RubyJmeter::DurationAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class DurationAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'DurationAssertion' : (params[:name] || 'DurationAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DurationAssertion guiclass="DurationAssertionGui" testclass="DurationAssertion" testname="#{testname}" enabled="true">
  <stringProp name="DurationAssertion.duration"/>
</DurationAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
