module RubyJmeter
  class DSL
    def constant_timer(params={}, &block)
      node = RubyJmeter::ConstantTimer.new(params)
      attach_node(node, &block)
    end
  end

  class ConstantTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'ConstantTimer'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConstantTimer guiclass="ConstantTimerGui" testclass="ConstantTimer" testname="#{params[:name]}" enabled="true">
  <stringProp name="ConstantTimer.delay">300</stringProp>
</ConstantTimer>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
