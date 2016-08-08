module RubyJmeter
  class ExtendedDSL < DSL
    include Parser
    attr_accessor :root

    def initialize(params = {})
      @root = Nokogiri::XML(<<-EOF.strip_heredoc)
        <?xml version="1.0" encoding="UTF-8"?>
        <jmeterTestPlan version="1.2" properties="2.9" jmeter="3.0" ruby-jmeter="3.0">
        <hashTree>
        </hashTree>
        </jmeterTestPlan>
      EOF
      node = RubyJmeter::TestPlan.new(params)

      @current_node = @root.at_xpath('//jmeterTestPlan/hashTree')
      @current_node = attach_to_last(node)
    end




    def with_user_agent(device)
      http_header_manager name: 'User-Agent',
                          value: RubyJmeter::UserAgent.new(device).string
    end

    def with_browser(device)
      http_header_manager name: 'User-Agent',
                          value: RubyJmeter::UserAgent.new(device).string
      http_header_manager [
        { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
        { name: 'Accept', value: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' }
      ]
    end

    def http_header_manager(params, &block)
      if params.is_a?(Hash)
        params['Header.name'] = params[:name]
      end
      super
    end

    alias_method :header, :http_header_manager

    alias_method :auth, :http_authorization_manager





    def with_xhr
      http_header_manager name: 'X-Requested-With',
                          value: 'XMLHttpRequest'
    end

    def with_gzip
      http_header_manager name: 'Accept-Encoding',
                          value: 'gzip, deflate'
    end

    def with_json
      http_header_manager name: 'Accept',
                          value: 'text/html, application/xhtml+xml, application/xml;q=0.9, */*;q=0.8, application/json'
    end


    def soapxmlrpc_request(params, &block)
      params[:method] ||= 'POST'
      super
    end

    alias_method :soap, :soapxmlrpc_request

    alias_method :ldap, :ldap_request

    alias_method :ldap_ext, :ldap_extended_request

    alias_method :ldap_extended, :ldap_extended_request

    ##
    # Controllers

    def transaction_controller(*args, &block)
      params = args.shift || {}
      params = { name: params }.merge(args.shift || {}) if params.class == String
      params[:parent] = params[:parent] || false
      params[:includeTimers] = params[:include_timers] || false
      node = RubyJmeter::TransactionController.new(params)
      attach_node(node, &block)
    end

    alias_method :transaction, :transaction_controller

    def exists(variable, &block)
      params ||= {}
      params[:condition] = "\"${#{variable}}\" != \"\\${#{variable}}\""
      params[:useExpression] = false
      params[:name] = "if ${#{variable}}"
      node = RubyJmeter::IfController.new(params)
      attach_node(node, &block)
    end

    alias_method :If, :if_controller

    def loop_controller(params, &block)
      params[:loops] = params[:count] || 1
      super
    end

    alias_method :Loop, :loop_controller

    def throughput_controller(params, &block)
      params[:style] = 1 if params[:percent]
      params[:maxThroughput] = params[:total] || params[:percent] || 1

      node = RubyJmeter::ThroughputController.new(params)
      node.doc.xpath(".//FloatProperty/value").first.content = params[:maxThroughput].to_f

      attach_node(node, &block)
    end

    alias_method :Throughput, :throughput_controller

    alias_method :Switch, :switch_controller

    alias_method :While, :while_controller

    alias_method :Interleave, :random_controller

    alias_method :Random_order, :random_order_controller

    alias_method :Simple, :simple_controller

    alias_method :Once, :once_only_controller

    ##
    # Listeners

    alias_method :view_results, :view_results_tree

    alias_method :log, :simple_data_writer

    alias_method :response_graph, :response_time_graph

    ##
    # Other Elements

    def module_controller(params, &block)
      node = RubyJmeter::ModuleController.new(params)

      if params[:test_fragment]
        params[:test_fragment].kind_of?(String) &&
        params[:test_fragment].split('/')
      elsif params[:node_path]
        params[:node_path]
      else
        []
      end.each_with_index do |node_name, index|
        node.doc.at_xpath('//collectionProp') <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="node_#{index}">#{node_name}</stringProp>
          EOS
      end

      attach_node(node, &block)
    end

    alias_method :bsh_pre, :beanshell_preprocessor

    alias_method :bsh_post, :beanshell_postprocessor

    def extract(params, &block)
      node = if params[:regex]
        params[:refname] = params[:name]
        params[:regex] = params[:regex] #CGI.escapeHTML
        params[:template] = params[:template] || "$1$"
        RubyJmeter::RegularExpressionExtractor.new(params)
      elsif params[:xpath]
        params[:refname] = params[:name]
        params[:xpathQuery] = params[:xpath]
        RubyJmeter::XpathExtractor.new(params)
      elsif params[:json]
        params[:VAR] = params[:name]
        params[:JSONPATH] = params[:json]
        RubyJmeter::Plugins::JsonPathExtractor.new(params)
      elsif params[:css]
        params[:refname] = params[:name]
        params[:expr] = params[:css]
        RubyJmeter::CssjqueryExtractor.new(params)
      end
      attach_node(node, &block)
    end

    alias_method :web_reg_save_param, :extract

    def random_timer(delay=0, range=0, &block)
      params = {}
      params[:delay] = delay
      params[:range] = range
      node = RubyJmeter::GaussianRandomTimer.new(params)
      attach_node(node, &block)
    end

    alias_method :think_time, :random_timer

    def constant_throughput_timer(params, &block)
      params[:value] ||= params[:throughput] || 0.0

      node = RubyJmeter::ConstantThroughputTimer.new(params)
      node.doc.xpath('.//value').first.content = params[:value].to_f

      attach_node(node, &block)
    end

    alias_method :ConstantThroughputTimer, :constant_throughput_timer

    ##
    # JMeter Plugins

    def response_codes_per_second(name = 'Response Codes per Second', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseCodesPerSecond.new(name, params)
      attach_node(node, &block)
    end

    def response_times_distribution(name = 'Response Times Distribution', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesDistribution.new(name, params)
      attach_node(node, &block)
    end

    def response_times_over_time(name = 'Response Times Over Time', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesOverTime.new(name, params)
      attach_node(node, &block)
    end

    def response_times_percentiles(name = 'Response Times Percentiles', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesPercentiles.new(name, params)
      attach_node(node, &block)
    end

    def transactions_per_second(name = 'Transactions per Second', params = {}, &block)
      node = RubyJmeter::Plugins::TransactionsPerSecond.new(name, params)
      attach_node(node, &block)
    end

    def latencies_over_time(name = 'Response Latencies Over Time', params = {}, &block)
      node = RubyJmeter::Plugins::LatenciesOverTime.new(name, params)
      attach_node(node, &block)
    end

    def console_status_logger(name = 'Console Status Logger', params = {}, &block)
      node = RubyJmeter::Plugins::ConsoleStatusLogger.new(name, params)
      attach_node(node, &block)
    end

    alias_method :console, :console_status_logger

    def throughput_shaper(name = 'Throughput Shaping Timer', steps=[], params = {}, &block)
      node = RubyJmeter::Plugins::ThroughputShapingTimer.new(name, steps)
      attach_node(node, &block)
    end

    alias_method :shaper, :throughput_shaper

    def dummy_sampler(name = 'Dummy Sampler', params = {}, &block)
      node = RubyJmeter::Plugins::DummySampler.new(name, params)
      attach_node(node, &block)
    end

    alias_method :dummy, :dummy_sampler

    def stepping_thread_group(params = {}, &block)
      node = RubyJmeter::Plugins::SteppingThreadGroup.new(params)
      attach_node(node, &block)
    end

    alias_method :step, :stepping_thread_group

    def ultimate_thread_group(threads = [], params = {}, &block)
      node = RubyJmeter::Plugins::UltimateThreadGroup.new(params)

      threads.each_with_index do |group, index|
        node.doc.at_xpath('//collectionProp') <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <collectionProp name="index">
              <stringProp name="#{group[:start_threads]}">#{group[:start_threads]}</stringProp>
              <stringProp name="#{group[:initial_delay]}">#{group[:initial_delay]}</stringProp>
              <stringProp name="#{group[:start_time]}">#{group[:start_time]}</stringProp>
              <stringProp name="#{group[:hold_time]}">#{group[:hold_time]}</stringProp>
              <stringProp name="#{group[:stop_time]}">#{group[:stop_time]}</stringProp>
            </collectionProp>
          EOS
      end

      attach_node(node, &block)
    end

    alias_method :ultimate, :ultimate_thread_group

    def composite_graph(name, params = {}, &block)
      node = RubyJmeter::Plugins::CompositeGraph.new(name, params)
      attach_node(node, &block)
    end

    alias_method :composite, :composite_graph

    def active_threads_over_time(params = {}, &block)
      node = RubyJmeter::Plugins::ActiveThreadsOverTime.new(params)
      attach_node(node, &block)
    end

    alias_method :active_threads, :active_threads_over_time

    def perfmon_collector(params = {}, &block)
      node = RubyJmeter::Plugins::PerfmonCollector.new(params)
      attach_node(node, &block)
    end

    alias_method :perfmon, :perfmon_collector

    def loadosophia_uploader(name = "Loadosophia.org Uploader", params = {}, &block)
      node = RubyJmeter::Plugins::LoadosophiaUploader.new(name, params)
      attach_node(node, &block)
    end

    alias_method :loadosophia, :loadosophia_uploader

    def redis_data_set(params = {}, &block)
      node = RubyJmeter::Plugins::RedisDataSet.new(params)
      attach_node(node, &block)
    end



    # API Methods

    def out(params = {})
      puts doc.to_xml(:indent => 2)
    end

    def jmx(params = {})
      file(params)
      logger.info "Test plan saved to: #{params[:file]}"
    end

    def to_xml
      doc.to_xml(:indent => 2)
    end

    def to_doc
      doc.clone
    end

    def run(params = {})
      file(params)
      logger.warn "Test executing locally ..."
      properties = params.has_key?(:properties) ? build_properties(params[:properties]) : "-q #{File.dirname(__FILE__)}/helpers/jmeter.properties"

      if params[:remote_hosts]
        remote_hosts = params[:remote_hosts]
        remote_hosts = remote_hosts.join(',') if remote_hosts.kind_of?(Array)
        remote_hosts = "-R #{remote_hosts}"
      end

      cmd = "#{params[:path]}jmeter #{"-n" unless params[:gui] } -t #{params[:file]} -j #{params[:log] ? params[:log] : 'jmeter.log' } -l #{params[:jtl] ? params[:jtl] : 'jmeter.jtl' } #{properties} #{remote_hosts}"
      logger.debug cmd if params[:debug]
      Open3.popen2e("#{cmd}") do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          logger.debug line.chomp if params[:debug]
        end

        exit_status = wait_thr.value
        abort "FAILED !!! #{cmd}" unless exit_status.success?
      end
      logger.info "Local Results at: #{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}"
    end

    def flood(token, params = {})
      if params[:region] == 'local'
        logger.info 'Starting test ...'
        params[:started] = Time.now
        run params
        params[:stopped] = Time.now
        logger.info 'Completed test ...'
        logger.debug 'Uploading results ...' if params[:debug]
      end
      RestClient.proxy = params[:proxy] if params[:proxy]
      begin
        file = Tempfile.new(['jmeter', '.jmx'])
        file.write(doc.to_xml(:indent => 2))
        file.rewind

        flood_files = {
          file: File.new("#{file.path}", 'rb')
        }

        if params[:files]
          flood_files.merge!(Hash[params[:files].map.with_index { |value, index| [index, File.new(value, 'rb')] }])
          params.delete(:files)
        end

        response = RestClient.post "#{params[:endpoint] ? params[:endpoint] : 'https://api.flood.io'}/floods?auth_token=#{token}",
        {
          :flood => {
            :tool => 'jmeter',
            :url => params[:url],
            :name => params[:name],
            :notes => params[:notes],
            :tag_list => params[:tag_list],
            :threads => params[:threads],
            :rampup => params[:rampup],
            :duration => params[:duration],
            :override_hosts => params[:override_hosts],
            :override_parameters => params[:override_parameters],
            # specials for API
            :started => params[:started],
            :stopped => params[:stopped]
          },
          :flood_files => flood_files,
          :results => (File.new("#{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}", 'rb') if params[:region] == 'local'),
          :region => params[:region],
          :multipart => true,
          :content_type => 'application/octet-stream'
        }.merge(params)
        if response.code == 201
          logger.info "Flood results at: #{JSON.parse(response)["permalink"]}"
        else
          logger.fatal "Sorry there was an error: #{JSON.parse(response)["error"]}"
        end
      rescue => e
        logger.fatal "Sorry there was an error: #{JSON.parse(e.response)["error"]}"
      end
    end

    alias_method :grid, :flood

    private

    def hash_tree
      Nokogiri::XML::Node.new("hashTree", @root)
    end

    def attach_to_last(node)
      ht        = hash_tree
      last_node = @current_node
      last_node << node.doc.children << ht
      ht
    end

    def attach_node(node, &block)
      ht            = attach_to_last(node)
      previous      = @current_node
      @current_node = ht
      instance_exec(&block) if block
      @current_node = previous
    end

    def file(params = {})
      params[:file] ||= 'jmeter.jmx'
      File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
    end

    def doc
      Nokogiri::XML(@root.to_s, &:noblanks)
    end

    def build_properties(properties)
      if properties.kind_of?(String)
        "-q #{properties}"
      elsif properties.kind_of?(Hash)
        properties.map{ |k,v| "-J#{k}=#{v}" }.join(" ")
      end
    end

    def logger
      @log       ||= Logger.new(STDOUT)
      @log.level = Logger::DEBUG
      @log
    end

    def json_path_assertion(params)
      params[:EXPECTED_VALUE] = params[:value]
      params[:JSON_PATH] = params[:json]
      RubyJmeter::Plugins::JsonPathAssertion.new(params)
    end
  end
end

def test(params = {}, &block)
  RubyJmeter.dsl_eval(RubyJmeter::ExtendedDSL.new(params), &block)
end
