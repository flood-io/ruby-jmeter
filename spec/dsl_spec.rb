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

  describe 'test plan' do
    it 'should allow to take params' do
      test_plan = test({"TestPlan.serialize_threadgroups" => "false"}) {}
      test_plan.to_doc.search("boolProp[@name='TestPlan.serialize_threadgroups']").text.should == "false"

      test_plan = test({"TestPlan.serialize_threadgroups" => "true"}) {}
      test_plan.to_doc.search("boolProp[@name='TestPlan.serialize_threadgroups']").text.should == "true"
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
