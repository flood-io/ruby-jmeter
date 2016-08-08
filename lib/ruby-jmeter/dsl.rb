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








    def soapxmlrpc_request(params, &block)
      params[:method] ||= 'POST'
      super
    end


    def exists(variable, &block)
      params ||= {}
      params[:condition] = "\"${#{variable}}\" != \"\\${#{variable}}\""
      params[:useExpression] = false
      params[:name] = "if ${#{variable}}"
      node = RubyJmeter::IfController.new(params)
      attach_node(node, &block)
    end



    ##
    # Listeners

    alias_method :view_results, :view_results_tree

    alias_method :log, :simple_data_writer

    alias_method :response_graph, :response_time_graph

    ##
    # Other Elements



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
