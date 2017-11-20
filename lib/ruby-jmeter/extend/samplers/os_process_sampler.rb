module RubyJmeter
  module OsProcessSamplerBuildArgs
    def initialize(params = {})
      super
      update_at_xpath build_args_xpath_update(params[:command_args] || {})
    end

    def build_args_xpath_update(args)
      {
        update_at_xpath: args.collect do |arg|
            {
              xpath: "//collectionProp[@name='Arguments.arguments']",
              value: Nokogiri::XML(<<-EOF.strip_heredoc).children
                                      <elementProp name="" elementType="Argument">
                                        <stringProp name="Argument.name"></stringProp>
                                        <stringProp name="Argument.value">#{arg}</stringProp>
                                        <stringProp name="Argument.metadata">=</stringProp>
                                      </elementProp>
                                    EOF
              }
          end
      }
    end
  end

  class OsProcessSampler
    prepend OsProcessSamplerBuildArgs
  end
end
