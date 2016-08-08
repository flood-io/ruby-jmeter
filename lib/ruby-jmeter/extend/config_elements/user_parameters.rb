module RubyJmeter
  class ExtendedDSL < DSL
    def user_parameters(params, &block)
      params['Argument.name'] = params[:name] if params.is_a?(Hash)

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

    alias parameters user_parameters
  end
end
