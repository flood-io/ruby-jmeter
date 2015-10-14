module RubyJmeter
  class ExtendedDSL < DSL
    include Parser
    attr_accessor :root

    def initialize(params = {})
      @root = Nokogiri::XML(<<-EOF.strip_heredoc)
        <?xml version="1.0" encoding="UTF-8"?>
        <jmeterTestPlan version="1.2" properties="2.8" jmeter="2.13" ruby-jmeter="2.13.0">
        <hashTree>
        </hashTree>
        </jmeterTestPlan>
      EOF
      node = RubyJmeter::TestPlan.new(params)

      @current_node = @root.at_xpath('//jmeterTestPlan/hashTree')
      @current_node = attach_to_last(node)
    end

    ##
    # Config Elements

    def user_defined_variables(params, &block)
      if params.is_a?(Hash)
        params['Argument.name'] = params[:name]
      end
      super
    end

    alias_method :variables, :user_defined_variables

    def http_request_defaults(params = {}, &block)
      params[:image_parser] = true if params.keys.include? :download_resources
      params[:concurrentDwn] = true if params.keys.include? :use_concurrent_pool
      params[:concurrentPool] = params[:use_concurrent_pool] if params.keys.include? :use_concurrent_pool
      params[:embedded_url_re] = params[:urls_must_match] if params.keys.include? :urls_must_match
      super
    end

    alias_method :defaults, :http_request_defaults

    def http_cookie_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration
      super
    end

    alias_method :cookies, :http_cookie_manager

    def http_cache_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration
      super
    end

    alias_method :cache, :http_cache_manager

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

    def thread_group(*args, &block)
      params = args.shift || {}
      params = { count: params }.merge(args.shift || {}) if params.class == Fixnum
      params[:num_threads] = params[:count] || 1
      params[:ramp_time] = params[:rampup] || (params[:num_threads]/2.0).ceil
      params[:start_time] = params[:start_time] || Time.now.to_i * 1000
      params[:end_time] = params[:end_time] || Time.now.to_i * 1000
      params[:duration] ||= 60
      params[:continue_forever] ||= false
      params[:loops] = -1 if params[:continue_forever]
      node = RubyJmeter::ThreadGroup.new(params)
      attach_node(node, &block)
    end

    alias_method :threads, :thread_group

    def setup_thread_group(*args, &block)
      params = args.shift || {}
      params = { count: params }.merge(args.shift || {}) if params.class == Fixnum
      params[:num_threads] = params[:count] || 1
      params[:ramp_time] = params[:rampup] || (params[:num_threads]/2.0).ceil
      params[:start_time] = params[:start_time] || Time.now.to_i * 1000
      params[:end_time] = params[:end_time] || Time.now.to_i * 1000
      params[:duration] ||= 60
      params[:continue_forever] ||= false
      params[:loops] = -1 if params[:continue_forever]
      node = RubyJmeter::SetupThreadGroup.new(params)
      attach_node(node, &block)
    end

    ##
    # HTTP Samplers

    def get(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'GET'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

    alias_method :visit, :get

    def post(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'POST'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

    alias_method :submit, :post

    def delete(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'DELETE'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

    def put(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'PUT'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

    def patch(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'PATCH'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

    def head(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String
      params[:method] ||= 'HEAD'
      params[:name] ||= params[:url]
      parse_http_request(params)
      node = RubyJmeter::HttpRequest.new(params)
      attach_node(node, &block)
    end

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

    def test_data(*args, &block)
      params = args.shift || {}
      params = { key: params.to_s }.merge(args.shift || {}) if(params.class == String || params.class == Symbol)
      params[:command] ||= 'SRANDMEMBER'
      params[:name] ||= 'testdata'
      params[:regex] ||= '"(.+?)"'
      params[:match_num] ||= -1
      params[:default] ||= ''

      params[:host] ||= '54.252.206.143'

      params[:url] = params[:key] if URI.parse(URI::encode(params[:key])).scheme

      params[:url] = if params[:host]
        "http://#{params[:host]}/data/#{params[:command]}/#{params[:key]}?type=text"
      end

      params[:url] = 'http://54.252.206.143/data/' if params[:stub]

      get name: '__testdata', url: params[:url] do
        extract name: params[:name],
          regex: params[:regex],
          match_num: params[:match_num],
          default: params[:default]
      end
    end

    ##
    # Other Samplers

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

    def user_parameters(params, &block)
      if params.is_a?(Hash)
        params['Argument.name'] = params[:name]
      end

      params[:names] = Nokogiri::XML::Builder.new do |b|
        b.builder do
          params[:names].each do |name|
            b.stringProp name, name: name
          end
        end
      end

      params[:thread_values] = Nokogiri::XML::Builder.new do |b|
        b.builder do
          params[:thread_values].map do |user, values|
            b.collectionProp name: user do
              values.each_with_index.map do |value, index|
                b.stringProp value, name: index
              end
            end
          end
        end
      end

      super
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

    def response_assertion(params = {}, &block)
      params[:test_type] = parse_test_type(params)
      params['0'] = params.values.first
      node = RubyJmeter::ResponseAssertion.new(params)
      if params[:variable] then
        params['Scope.variable'] = params[:variable]
        node.doc.xpath("//stringProp[@name='Assertion.scope']").first.content = 'variable'
      end
      node.doc.xpath("//stringProp[@name='Assertion.scope']").remove if
        params[:scope] == 'main' || params['scope'] == 'main'
      attach_node(node, &block)
    end

    alias_method :assert, :response_assertion

    alias_method :web_reg_find, :response_assertion

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

    def ultimate_thread_group(params = {}, &block)
      node = RubyJmeter::Plugins::UltimateThreadGroup.new(params)

      params.each_with_index do |group, index|
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

    def perfmon_collector(name, params = {}, filename="perfMon.jtl", xml=true, &block)
      node = RubyJmeter::Plugins::PerfmonCollector.new(name, params, filename, xml)
      attach_node(node, &block)
    end

    alias_method :perfmon, :perfmon_collector

    def loadosophia_uploader(name = "Loadosophia.org Uploader", params = {}, &block)
      node = RubyJmeter::Plugins::LoadosophiaUploader.new(name, params)
      attach_node(node, &block)
    end

    alias_method :loadosophia, :loadosophia_uploader



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
  end
end

def test(params = {}, &block)
  RubyJmeter.dsl_eval(RubyJmeter::ExtendedDSL.new(params), &block)
end
