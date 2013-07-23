module RubyJmeter
  class DSL
    def regex_user_parameters(params={}, &block)
      node = RubyJmeter::RegexUserParameters.new(params)
      attach_node(node, &block)
    end
  end

  class RegexUserParameters
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'RegexUserParameters'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RegExUserParameters guiclass="RegExUserParametersGui" testclass="RegExUserParameters" testname="#{params[:name]}" enabled="true">
  <stringProp name="RegExUserParameters.regex_ref_name"/>
  <stringProp name="RegExUserParameters.param_names_gr_nr"/>
  <stringProp name="RegExUserParameters.param_values_gr_nr"/>
</RegExUserParameters>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
