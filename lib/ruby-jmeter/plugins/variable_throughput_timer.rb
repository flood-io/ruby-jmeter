module RubyJmeter
  module Plugins
    class ThroughputShapingTimer
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'ThroughputShapingTimer' : (params[:name] || 'ThroughputShapingTimer')
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <kg.apc.jmeter.timers.VariableThroughputTimer guiclass="kg.apc.jmeter.timers.VariableThroughputTimerGui" testclass="kg.apc.jmeter.timers.VariableThroughputTimer" testname="#{testname}" enabled="true">
            <collectionProp name="load_profile"/>
          </kg.apc.jmeter.timers.VariableThroughputTimer>
        EOF
        (params.kind_of?(Array) ? params : params[:steps]).each_with_index do |step, index|
          @doc.at_xpath('//collectionProp') <<
            Nokogiri::XML(<<-EOF.strip_heredoc).children
              <collectionProp name="step_#{index}">
                <stringProp name="start_rps_#{index}">#{step[:start_rps]}</stringProp>
                <stringProp name="end_rps_#{index}">#{step[:end_rps]}</stringProp>
                <stringProp name="duration_sec_#{index}">#{step[:duration]}</stringProp>
              </collectionProp>
            EOF
        end
        update params
      end
    end
  end
end
