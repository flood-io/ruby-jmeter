module RubyJmeter
  class DSL
    def random_controller(params={}, &block)
      node = RubyJmeter::RandomController.new(params)
      attach_node(node, &block)
    end
  end

  class RandomController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'RandomController' : (params[:name] || 'RandomController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RandomController guiclass="RandomControlGui" testclass="RandomController" testname="#{testname}" enabled="true">
  <intProp name="InterleaveControl.style">1</intProp>
</RandomController>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
