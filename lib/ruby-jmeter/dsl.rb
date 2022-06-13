module RubyJmeter
  class ExtendedDSL < DSL
    include Parser
    attr_accessor :root

    def initialize(params = {})
      @root = Nokogiri::XML(<<-EOF.strip_heredoc)
        <?xml version="1.0" encoding="UTF-8"?>
        <jmeterTestPlan version="1.2" properties="3.1" jmeter="3.1" ruby-jmeter="3.0">
        <hashTree>
        </hashTree>
        </jmeterTestPlan>
      EOF
      node = RubyJmeter::TestPlan.new(params)

      @current_node = @root.at_xpath('//jmeterTestPlan/hashTree')
      @current_node = attach_to_last(node)
    end

    def out(params = {})
      puts doc.to_xml(indent: 2)
    end

    def jmx(params = {})
      file(params)
      logger.info "Test plan saved to: #{params[:file]}"
    end

    def to_xml
      doc.to_xml(indent: 2)
    end

    def to_doc
      doc.clone
    end

    def run(params = {})
      file(params)
      html_output_path(params)
      jtl_file(params)
      logger.warn 'Test executing locally ...'

      cmd = "#{params[:path] ? File.join(params[:path], 'jmeter') : 'jmeter'} #{"-n" unless params[:gui] } -t #{params[:file]} -j #{params[:log] ? params[:log] : 'jmeter.log' } -l #{params[:jtl]} #{"-e -o " + params[:html_output] unless params[:gui]} #{build_properties(params[:properties]) if params[:properties]}"
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

    private

    def hash_tree
      Nokogiri::XML::Node.new("hashTree", @root)
    end

    def attach_to_last(node)
      ht = hash_tree
      last_node = @current_node
      last_node << node.doc.children << ht
      ht
    end

    def attach_node(node, &block)
      ht = attach_to_last(node)
      previous = @current_node
      @current_node = ht
      instance_exec(&block) if block
      @current_node = previous
    end

    def file(params = {})
      params[:file] ||= 'ruby-jmeter.jmx'
      File.open(params[:file], 'w') { |file| file.write(doc.to_xml(indent: 2)) }
    end

    def html_output_path(params = {})
      params[:html_output] ||= 'jmeter_output'
      if File.directory?( params[:html_output])
        FileUtils.rm_rf(params[:html_output])
      end
    end

    def jtl_file(params = {})
      params[:jtl] ||= 'jmeter.jtl'
      if File.file?(params[:jtl])
        File.delete(params[:jtl])
      end
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
      @log ||= Logger.new(STDOUT)
      @log.level = Logger::DEBUG
      @log
    end
  end
end

def test(params = {}, &block)
  RubyJmeter.dsl_eval(RubyJmeter::ExtendedDSL.new(params), &block)
end
