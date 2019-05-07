module RubyJmeter
  module Plugins
    class WebDriverSampler
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'jp@gc - WebDriver Sampler' : (params[:name] || 'jp@gc - WebDriver Sampler')
        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
          <com.googlecode.jmeter.plugins.webdriver.sampler.WebDriverSampler guiclass="com.googlecode.jmeter.plugins.webdriver.sampler.gui.WebDriverSamplerGui" testclass="com.googlecode.jmeter.plugins.webdriver.sampler.WebDriverSampler" testname="#{testname}" enabled="true">
          <stringProp name="WebDriverSampler.script"></stringProp>
          <stringProp name="WebDriverSampler.parameters"></stringProp>
          <stringProp name="WebDriverSampler.language">javascript</stringProp>
        </com.googlecode.jmeter.plugins.webdriver.sampler.WebDriverSampler>
        XML
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
