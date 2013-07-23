module RubyJmeter
  class DSL
    def transaction_controller(params={}, &block)
      node = RubyJmeter::TransactionController.new(params)
      attach_node(node, &block)
    end
  end

  class TransactionController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'TransactionController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{params[:name]}" enabled="true">
  <boolProp name="TransactionController.parent">true</boolProp>
  <boolProp name="TransactionController.includeTimers">false</boolProp>
</TransactionController>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
