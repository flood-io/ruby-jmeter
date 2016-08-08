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
