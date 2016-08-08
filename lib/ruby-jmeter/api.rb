module RubyJmeter
  class ExtendedDSL < DSL
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
      logger.warn 'Test executing locally ...'
      properties = params.has_key?(:properties) ? build_properties(params[:properties]) : "-q #{File.dirname(__FILE__)}/helpers/jmeter.properties"

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
      RestClient.proxy = params[:proxy] if params[:proxy]
      begin
        file = Tempfile.new(['ruby-jmeter', '.jmx'])
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
            :name => params[:name],
            :notes => params[:notes],
            :tag_list => params[:tag_list],
            :threads => params[:threads],
            :rampup => params[:rampup],
            :duration => params[:duration],
            :override_parameters => params[:override_parameters],
            :started => params[:started],
            :stopped => params[:stopped]
          },
          :flood_files => flood_files,
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
  end
end
