module RubyJmeter
  class ExtendedDSL < DSL
    def rsync(params = {})
      logger.warn "Test file upload via rsync ..."

      file(params)

      cmd = "#{params[:rsync_bin_path]} #{params[:rsync_params]} #{params[:file]} #{params[:remote_user]}@#{params[:remote_host]}:#{params[:remote_path]}"

      logger.debug cmd if params[:debug]

      Open3.popen2e("#{cmd}") do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          logger.debug line.chomp if params[:debug]
        end

        exit_status = wait_thr.value
        abort "Sorry there was an error: #{cmd}" unless exit_status.success?
      end

      logger.info "Upload complete at: #{params[:remote_host]}:#{params[:remote_path]}"
    end
  end
end
