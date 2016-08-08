require 'spec_helper'

describe 'DSL' do
  describe 'write to stdout and file' do
    it 'should output a test plan to stdout' do
      $stdout.should_receive(:puts).with(/jmeterTestPlan/i)
      test do
      end.out
    end

    it 'should output a test plan to jmx file' do
      file = double('file')
      File.should_receive(:open).with('jmeter.jmx', 'w').and_yield(file)
      file.should_receive(:write).with(/jmeterTestPlan/i)
      test do
      end.jmx
    end
  end



  describe 'disabled elements' do
    let(:doc) do
      test do
        header name: 'Accept', value: '*', enabled: false
      end.to_doc
    end

    let(:fragment) {  doc.search('//HeaderManager') }

    it 'should be disabled' do
      fragment.first.attributes['enabled'].value.should == 'false'
    end
  end





  describe 'test plan' do
    it 'should allow to take params' do
      test_plan = test({"TestPlan.serialize_threadgroups" => "false"}) {}
      test_plan.to_doc.search("boolProp[@name='TestPlan.serialize_threadgroups']").text.should == "false"

      test_plan = test({"TestPlan.serialize_threadgroups" => "true"}) {}
      test_plan.to_doc.search("boolProp[@name='TestPlan.serialize_threadgroups']").text.should == "true"
    end
  end





















  describe 'If' do
    let(:doc) do
      test do
        threads do
          If condition: '2>1' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on If' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == '2>1'
    end
  end

  describe 'exists' do
    let(:doc) do
      test do
        threads do
          exists 'apple' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on exists' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == '"${apple}" != "\${apple}"'
    end
  end

  describe 'While' do
    let(:doc) do
      test do
        threads do
          While condition: 'true' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//WhileController').first }

    it 'should match on While' do
      fragment.search(".//stringProp[@name='WhileController.condition']").text.should == 'true'
    end
  end



  describe 'Counter' do
    let(:doc) do
      test do
        threads do
          visit url: "/" do
            counter start: 1, per_user: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//CounterConfig').first }

    it 'should match on 5 Loops' do
      fragment.search(".//boolProp[@name='CounterConfig.per_user']").text.should == 'true'
    end
  end

  describe 'Switch' do
    let(:doc) do
      test do
        threads do
          Switch value: 'cat' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//SwitchController').first }

    it 'should match on Switch' do
      fragment.search(".//stringProp[@name='SwitchController.value']").text.should == 'cat'
    end
  end

  describe 'xpath extract' do
    let(:doc) do
      test do
        extract xpath: '//node', name: 'my_xpath'
      end.to_doc
    end

    let(:fragment) { doc.search('//XPathExtractor').first }

    it 'should match on refname' do
      fragment.search(".//stringProp[@name='XPathExtractor.refname']").text.should == 'my_xpath'
    end
  end

  describe 'json extract' do
    let(:doc) do
      test do
        extract json: '.test.path', name: 'my_json'
      end.to_doc
    end

    let(:fragment) { doc.search("//com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor").first }

    it 'should match on json path and var' do
      fragment.search(".//stringProp[@name='JSONPATH']").text.should == '.test.path'
      fragment.search(".//stringProp[@name='VAR']").text.should == 'my_json'
    end
  end


  describe 'assertions' do
    describe 'json assertion' do
      let(:doc) do
        test do
          visit '/' do
            assert json: '.key', value: 'value'
          end
        end.to_doc
      end

      let(:fragment) { doc.search('//com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion').first }

      it 'should match on expected value' do
        fragment.search(".//stringProp[@name='EXPECTED_VALUE']").text.should == "value"
      end

      it 'should match on json path' do
        fragment.search(".//stringProp[@name='JSON_PATH']").text.should == ".key"
      end

      it 'should have json validation by default' do
        fragment.search(".//boolProp[@name='JSONVALIDATION']").text.should == "true"
      end
    end

    describe 'scope main' do
      let(:doc) do
        test do
          visit '/' do
            assert contains: 'Welcome', scope: 'main'
          end
        end.to_doc
      end

      let(:fragment) { doc.search('//ResponseAssertion').first }

      it 'should match on scope' do
        fragment.search(".//stringProp[@name='Assertion.scope']").text.should == ""
      end
    end
  end

  describe 'Nested controllers' do
    let(:doc) do
      test do
        Simple name: 'node1.1' do
          Simple name: 'node2.1'
          Simple name: 'node2.2' do
            Simple name: 'node3.1'
          end
          Simple name: 'node2.3'
        end
        Simple name: 'node1.2'
      end.to_doc
    end

    let(:node1_1) { doc.search("//GenericController[@testname='node1.1']").first }
    let(:node1_2) { doc.search("//GenericController[@testname='node1.2']").first }

    let(:node2_1) { doc.search("//GenericController[@testname='node2.1']").first }
    let(:node2_2) { doc.search("//GenericController[@testname='node2.2']").first }
    let(:node2_3) { doc.search("//GenericController[@testname='node2.3']").first }

    let(:node3_1) { doc.search("//GenericController[@testname='node3.1']").first }

    it 'nodes should have hashTree as its parent' do
      [node1_1, node1_2, node2_1, node2_2, node2_3, node3_1].each do |node|
        node.parent.name.should == 'hashTree'
      end
    end

    describe 'node3_1' do
      it 'parent parent should be node2_2' do
        node3_1.parent.should == node2_2.next
      end
    end

    describe 'node1_2' do
      it 'previous non hashTree sibling is node1_1' do
        node1_2.previous.previous.should == node1_1
      end
    end
  end

  describe 'raw body containing xml entities' do
    let(:doc) do
      test do
        threads do
          post url: 'http://example.com', raw_body: 'username=my_name&password=my_password&email="my name <test@example.com>"'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'escape raw_body' do
      fragment.search(".//stringProp[@name='Argument.value']").text.should == 'username=my_name&password=my_password&email="my name <test@example.com>"'
    end
  end

  describe 'constant_throughput_timer' do
    let(:doc) do
      test do
        threads do
          constant_throughput_timer value: 60.0
          constant_throughput_timer throughput: 70.0
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//ConstantThroughputTimer").first }

    it 'should match on throughput using value' do
      fragment.search("//doubleProp/value").first.text.should == '60.0'
    end

    it 'should match on throughput using throughput' do
      fragment.search("//doubleProp/value").last.text.should == '70.0'
    end
  end

  describe 'run' do
    let(:deflate_properties) {
      File.expand_path('../../lib/ruby-jmeter/helpers/jmeter.properties', __FILE__)
    }

    it 'pass a properties file' do
      Open3.should_receive(:popen2e)
           .with('jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl -q my-jmeter.properties ')

      test do
      end.run(properties: 'my-jmeter.properties')
    end

    it 'pass an inline property' do
      Open3.should_receive(:popen2e)
           .with('jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl -Jjmeter.save.saveservice.output_format=xml ')

      test do
      end.run(properties: {"jmeter.save.saveservice.output_format" => "xml"})
    end

    it 'pass multiple inline properties' do
      Open3.should_receive(:popen2e)
           .with('jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl -Jtlon=uqbar -Jorbis=tertius ')

      test do
      end.run(properties: {tlon: "uqbar", orbis: "tertius"})
    end

    it 'do not pass a properties file' do
      Open3.should_receive(:popen2e)
           .with("jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl -q #{deflate_properties} ")

      test do
      end.run
    end

    it 'pass a nil properties file' do
      Open3.should_receive(:popen2e)
           .with('jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl  ')

      test do
      end.run(properties: nil)
    end

    it 'pass remote hosts' do
      Open3.should_receive(:popen2e)
           .with("jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl  -R 192.168.1.1,192.168.1.2")

      test do
      end.run(properties: nil, remote_hosts: '192.168.1.1,192.168.1.2')
    end

    it 'pass remote hosts (Array)' do
      Open3.should_receive(:popen2e)
           .with('jmeter -n -t jmeter.jmx -j jmeter.log -l jmeter.jtl  -R 192.168.1.1,192.168.1.2')

      test do
      end.run(properties: nil, remote_hosts: ['192.168.1.1', '192.168.1.2'])
    end
  end




end
