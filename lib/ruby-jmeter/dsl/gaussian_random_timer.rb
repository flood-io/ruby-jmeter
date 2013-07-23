module RubyJmeter
  class DSL
    def gaussian_random_timer(params={}, &block)
      node = RubyJmeter::GaussianRandomTimer.new(params)
      attach_node(node, &block)
    end
  end

  class GaussianRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'GaussianRandomTimer'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="#{params[:name]}" enabled="true">
  <stringProp name="ConstantTimer.delay">300</stringProp>
  <stringProp name="RandomTimer.range">100.0</stringProp>
</GaussianRandomTimer>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
