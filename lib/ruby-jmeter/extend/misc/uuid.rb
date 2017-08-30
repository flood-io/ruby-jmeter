module RubyJmeter
  class ExtendedDSL < DSL
    def uuid_per_iteration(params = {}, &block)
      params[:name] ||= '__UUID'
      params[:variable] ||= 'UUID'

      dummy_sampler name: params[:name], response_data: '${__UUID}' do
        regex pattern: '(.*)', name: params[:variable], match_number: 1
      end
    end
  end
end
