module RubyJmeter
  class DSL
    def recording_controller(params={}, &block)
      node = RubyJmeter::RecordingController.new(params)
      attach_node(node, &block)
    end
  end

  class RecordingController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'RecordingController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RecordingController guiclass="RecordController" testclass="RecordingController" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
