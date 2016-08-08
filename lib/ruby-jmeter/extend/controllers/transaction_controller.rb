module RubyJmeter
  class ExtendedDSL < DSL
    def transaction_controller(*args, &block)
      params = args.shift || {}
      params = { name: params }.merge(args.shift || {}) if params.class == String
      params[:parent] = params[:parent] || false
      params[:includeTimers] = params[:include_timers] || false
      node = RubyJmeter::TransactionController.new(params)
      attach_node(node, &block)
    end

    alias transaction transaction_controller
  end
end
