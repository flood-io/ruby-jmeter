module RubyJmeter
  module Plugins
    class RedisDataSet
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'Redis Data Set Config' : (params[:name] || 'Redis Data Set Config')
        params[:getMode] ||= "1" unless params[:remove] == true
        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
          <kg.apc.jmeter.config.redis.RedisDataSet guiclass="TestBeanGUI" testclass="kg.apc.jmeter.config.redis.RedisDataSet" testname="#{testname}" enabled="true">
            <stringProp name="database">0</stringProp>
            <stringProp name="delimiter">,</stringProp>
            <intProp name="getMode">0</intProp>
            <stringProp name="host"></stringProp
            <intProp name="maxActive">20</intProp>
            <intProp name="maxIdle">10</intProp>
            <longProp name="maxWait">30000</longProp>
            <longProp name="minEvictableIdleTimeMillis">60000</longProp>
            <intProp name="minIdle">0</intProp>
            <intProp name="numTestsPerEvictionRun">0</intProp>
            <stringProp name="password"></stringProp>
            <stringProp name="port">6379</stringProp>
            <stringProp name="redisKey"></stringProp>
            <longProp name="softMinEvictableIdleTimeMillis">60000</longProp>
            <boolProp name="testOnBorrow">false</boolProp>
            <boolProp name="testOnReturn">false</boolProp>
            <boolProp name="testWhileIdle">false</boolProp>
            <longProp name="timeBetweenEvictionRunsMillis">30000</longProp>
            <stringProp name="timeout">2000</stringProp>
            <stringProp name="variableNames"></stringProp>
            <intProp name="whenExhaustedAction">2</intProp>
          </kg.apc.jmeter.config.redis.RedisDataSet>
        XML
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
