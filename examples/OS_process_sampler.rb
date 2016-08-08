$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

build_args = ->(args) do
  args.collect do |arg|
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
end


test do
  os_process_sampler 'SystemSampler.command' => 'git',
                      update_at_xpath: build_args.call(['push', 'origin', 'master'])

end.run(path: '/usr/share/jmeter/bin/', gui: true)
