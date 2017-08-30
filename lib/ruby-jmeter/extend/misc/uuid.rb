module RubyJmeter
  class ExtendedDSL < DSL
    def uuid(params = {})
      params[:name] ||= '__UUID'
      params[:variable] ||= 'UUID'

      node = RubyJmeter::Plugins::DummySampler.new(params).tap do |node|
      end

      attach_node(node, &block)

      # dummy_sampler name: params[:name], response_data: '${__UUID}' do
      #   regex pattern: "(.*)", name: params[:variable], match_number: 1
      # end
    end
  end
end
