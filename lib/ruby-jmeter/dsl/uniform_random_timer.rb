module RubyJmeter
  class DSL
    def uniform_random_timer(params={}, &block)
      node = RubyJmeter::UniformRandomTimer.new(params)
      attach_node(node, &block)
    end
  end

  class UniformRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'UniformRandomTimer'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<UniformRandomTimer guiclass="UniformRandomTimerGui" testclass="UniformRandomTimer" testname="#{params[:name]}" enabled="true">
  <stringProp name="ConstantTimer.delay">0</stringProp>
  <stringProp name="RandomTimer.range">100.0</stringProp>
</UniformRandomTimer>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
