module RubyJmeter
  class DSL
    def runtime_controller(params={}, &block)
      node = RubyJmeter::RuntimeController.new(params)
      attach_node(node, &block)
    end
  end

  class RuntimeController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'RuntimeController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RunTime guiclass="RunTimeGui" testclass="RunTime" testname="#{params[:name]}" enabled="true">
  <stringProp name="RunTime.seconds">1</stringProp>
</RunTime>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
