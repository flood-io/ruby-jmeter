module RubyJmeter
  module Plugins
    class WebDriverChromeDriver
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'jp@gc - Chrome Driver Config' : (params[:name] || 'jp@gc - Chrome Driver Config')
        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
          <com.googlecode.jmeter.plugins.webdriver.config.ChromeDriverConfig guiclass="com.googlecode.jmeter.plugins.webdriver.config.gui.ChromeDriverConfigGui" testclass="com.googlecode.jmeter.plugins.webdriver.config.ChromeDriverConfig" testname="#{testname}" enabled="true">
          <stringProp name="WebDriverConfig.proxy_type">SYSTEM</stringProp>
          <stringProp name="WebDriverConfig.proxy_pac_url"></stringProp>
          <stringProp name="WebDriverConfig.http_host"></stringProp>
          <intProp name="WebDriverConfig.http_port">8080</intProp>
          <boolProp name="WebDriverConfig.use_http_for_all_protocols">true</boolProp>
          <stringProp name="WebDriverConfig.https_host"></stringProp>
          <intProp name="WebDriverConfig.https_port">8080</intProp>
          <stringProp name="WebDriverConfig.ftp_host"></stringProp>
          <intProp name="WebDriverConfig.ftp_port">8080</intProp>
          <stringProp name="WebDriverConfig.socks_host"></stringProp>
          <intProp name="WebDriverConfig.socks_port">8080</intProp>
          <stringProp name="WebDriverConfig.no_proxy">localhost</stringProp>
          <boolProp name="WebDriverConfig.maximize_browser">true</boolProp>
          <boolProp name="WebDriverConfig.reset_per_iteration">false</boolProp>
          <boolProp name="WebDriverConfig.dev_mode">false</boolProp>
          <stringProp name="ChromeDriverConfig.chromedriver_path"></stringProp>
          <boolProp name="ChromeDriverConfig.android_enabled">false</boolProp>
          <boolProp name="ChromeDriverConfig.headless_enabled">false</boolProp>
          <boolProp name="ChromeDriverConfig.insecurecerts_enabled">false</boolProp>
        </com.googlecode.jmeter.plugins.webdriver.config.ChromeDriverConfig>
        XML
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
