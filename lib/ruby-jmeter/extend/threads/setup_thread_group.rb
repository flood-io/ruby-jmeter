module RubyJmeter
  class ExtendedDSL < DSL
    def setup_thread_group(*args, &block)
      params = args.shift || {}
      params = { count: params }.merge(args.shift || {}) if params.is_a?(Integer)
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
  end
end
