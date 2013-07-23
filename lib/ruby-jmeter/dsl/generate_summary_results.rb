module RubyJmeter
  class DSL
    def generate_summary_results(params={}, &block)
      node = RubyJmeter::GenerateSummaryResults.new(params)
      attach_node(node, &block)
    end
  end

  class GenerateSummaryResults
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'GenerateSummaryResults'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<Summariser guiclass="SummariserGui" testclass="Summariser" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
