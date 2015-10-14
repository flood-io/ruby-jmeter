require 'spec_helper'
require 'pry'

describe 'DSL' do
  describe 'aliased DSL methods' do
    it "test plan should respond to aliased methods" do
      test {}.should respond_to :variables
      test {}.should respond_to :defaults
      test {}.should respond_to :cookies
      test {}.should respond_to :cache
      test {}.should respond_to :header
      test {}.should respond_to :auth
    end
  end

  describe 'write to stdout and file' do
    it "should output a test plan to stdout" do
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

  describe 'user agent' do
    let(:doc) do
      test do
        with_user_agent :chrome
        threads
      end.to_doc
    end

    let(:fragment) { doc.search('//HeaderManager').first }

    it 'should match on user_agent' do
      fragment.search(".//stringProp[@name='Header.name']").text.should == 'User-Agent'
      fragment.search(".//stringProp[@name='Header.value']").text.should ==
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5'
    end
  end

  describe 'http request defaults' do
    let(:doc) do
      test do
        defaults domain: 'example.com',
            protocol: 'https',
            implementation: 'HttpClient3.1',
            download_resources: true,
            use_concurrent_pool: 5,
            urls_must_match: 'http.+?example.com'
        threads do
          visit url: "/"
        end
      end.to_doc
    end

    let(:config_fragment) { doc.search('//ConfigTestElement').first }
    let(:sampler_fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on implementation' do
      sampler_fragment.search(".//stringProp[@name='HTTPSampler.implementation']").text.should == ''
    end

    it 'should match on defaults' do
      config_fragment.search(".//stringProp[@name='HTTPSampler.domain']").text.should == 'example.com'
      config_fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text.should == 'https'
      config_fragment.search(".//stringProp[@name='HTTPSampler.implementation']").text.should == 'HttpClient3.1'
      config_fragment.search(".//boolProp[@name='HTTPSampler.image_parser']").text.should == 'true'
      config_fragment.search(".//boolProp[@name='HTTPSampler.concurrentDwn']").text.should == 'true'
      config_fragment.search(".//stringProp[@name='HTTPSampler.concurrentPool']").text.should == '5'
      config_fragment.search(".//stringProp[@name='HTTPSampler.embedded_url_re']").text.should == 'http.+?example.com'
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

  describe 'header manager' do
    let(:doc) do
      test do
        header name: 'Accept', value: '*'
      end.to_doc
    end

    let(:fragment) { doc.search('//HeaderManager').first }

    it 'should match on accept' do
      fragment.search(".//stringProp[@name='Header.name']").text.should == 'Accept'
      fragment.search(".//stringProp[@name='Header.value']").text.should == '*'
    end
  end

  describe 'header manager multiple values' do
    let(:doc) do
      test do
        header [ { name: 'Accept', value: '1' }, { name: 'Accept', value: '2' }]
      end.to_doc
    end

    let(:fragment) { doc.search('//HeaderManager') }


    it 'should match on accept for fragment_first' do
      fragment.search(".//stringProp[@name='Header.name']").first.text.should == 'Accept'
      fragment.search(".//stringProp[@name='Header.value']").first.text.should == '1'
    end

    it 'should match on accept for fragment_last' do
      fragment.search(".//stringProp[@name='Header.name']").last.text.should == 'Accept'
      fragment.search(".//stringProp[@name='Header.value']").last.text.should == '2'
    end
  end

  describe 'the clear_each_iteration option should be respected' do
    let(:doc) do
      test do
        cache clear_each_iteration: true
        cookies clear_each_iteration: true
      end.to_doc
    end

    let(:cache_fragment) { doc.search("//CacheManager") }
    let(:cookies_fragment) { doc.search("//CookieManager") }

    it 'should match on clearEachIteration' do
      cache_fragment.search(".//boolProp[@name='clearEachIteration']").first.text.should == 'true'
      cookies_fragment.search(".//boolProp[@name='CookieManager.clearEachIteration']").first.text.should == 'true'
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

  describe 'thread groups' do
    let(:doc) do
      test do
        threads count: 101, continue_forever: true, duration: 69
      end.to_doc
    end

    let(:fragment) { doc.search("//ThreadGroup").first }

    it 'should match on num_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '101'
    end

    it 'should match on scheduler' do
      fragment.search(".//boolProp[@name='ThreadGroup.scheduler']").text.should == 'true'
    end

    it 'should match on continue_forever' do
      fragment.search(".//boolProp[@name='LoopController.continue_forever']").text.should == 'true'
    end

    it 'should match on loops' do
      fragment.search(".//intProp[@name='LoopController.loops']").text.should == '-1'
    end

    it 'should match on duration' do
      fragment.search(".//stringProp[@name='ThreadGroup.duration']").text.should == '69'
    end
  end

  describe 'setup thread groups' do
    let(:doc) do
      test do
        setup_thread_group count: 101, continue_forever: true, duration: 69
      end.to_doc
    end

    let(:fragment) { doc.search("//SetupThreadGroup").first }

    it 'should match on num_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '101'
    end

    it 'should match on scheduler' do
      fragment.search(".//boolProp[@name='ThreadGroup.scheduler']").text.should == 'true'
    end

    it 'should match on continue_forever' do
      fragment.search(".//boolProp[@name='LoopController.continue_forever']").text.should == 'true'
    end

    it 'should match on loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '-1'
    end

    it 'should match on duration' do
      fragment.search(".//stringProp[@name='ThreadGroup.duration']").text.should == '69'
    end
  end

  describe 'stepping thread group' do
    let(:doc) do
      test do
        stepping_thread_group on_sample_error: 'startnextloop', total_threads: 100, initial_delay: 1, start_threads: 2, add_threads: 3, start_every: 4, stop_threads: 5, stop_every: 6, flight_time: 7, rampup: 8
      end.to_doc
    end

    let(:fragment) { doc.search("//kg.apc.jmeter.threads.SteppingThreadGroup").first }
    it 'should match on on_sample_error' do
      fragment.search(".//stringProp[@name='ThreadGroup.on_sample_error']").text.should == 'startnextloop'
    end

    it 'should match on total_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '100'
    end

    it 'should match on initial_delay' do
      fragment.search(".//stringProp[@name='Threads initial delay']").text.should == '1'
    end

    it 'should match on start_threads' do
      fragment.search(".//stringProp[@name='Start users count']").text.should == '2'
    end

    it 'should match on add_threads' do
      fragment.search(".//stringProp[@name='Start users count burst']").text.should == '3'
    end

    it 'should match on start_every' do
      fragment.search(".//stringProp[@name='Start users period']").text.should == '4'
    end

    it 'should match on stop_threads' do
      fragment.search(".//stringProp[@name='Stop users count']").text.should == '5'
    end

    it 'should match on stop_every' do
      fragment.search(".//stringProp[@name='Stop users period']").text.should == '6'
    end

    it 'should match on flight_time' do
      fragment.search(".//stringProp[@name='flighttime']").text.should == '7'
    end

    it 'should match on rampup' do
      fragment.search(".//stringProp[@name='rampUp']").text.should == '8'
    end
  end

  describe 'thread groups old syntax' do
    let(:doc) do
      test do
        threads 101, continue_forever: true, duration: 69
      end.to_doc
    end

    let(:fragment) { doc.search("//ThreadGroup").first }

    it 'should match on num_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '101'
    end

    it 'should match on continue_forever' do
      fragment.search(".//boolProp[@name='LoopController.continue_forever']").text.should == 'true'
    end

    it 'should match on loops' do
      fragment.search(".//intProp[@name='LoopController.loops']").text.should == '-1'
    end

    it 'should match on duration' do
      fragment.search(".//stringProp[@name='ThreadGroup.duration']").text.should == '69'
    end
  end

  describe 'transaction controller' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: false, include_timers: true
          transaction name: "TC_02", parent: true, include_timers: false
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//TransactionController") }

    it 'should match on parent when false' do
      fragment.first.search(".//boolProp[@name='TransactionController.parent']").text.should == 'false'
    end

    it 'should match on includeTimers when true' do
      fragment.first.search(".//boolProp[@name='TransactionController.includeTimers']").text.should == 'true'
    end

    it 'should match on parent when true' do
      fragment.last.search(".//boolProp[@name='TransactionController.parent']").text.should == 'true'
    end

    it 'should match on includeTimers when false' do
      fragment.last.search(".//boolProp[@name='TransactionController.includeTimers']").text.should == 'false'
    end
  end

  describe 'throughput controller' do
    let(:doc) do
      test do
        threads do
          throughput_controller percent: 99 do
            transaction name: "TC_01", parent: true, include_timers: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//ThroughputController").first }

    it 'should match on maxThroughput' do
      # puts doc.to_xml indent: 2
      fragment.search(".//intProp[@name='ThroughputController.maxThroughput']").text.should == '99'
      fragment.search(".//FloatProperty/value").text.should == '99.0'
    end

    it 'should match on style' do
      fragment.search(".//intProp[@name='ThroughputController.style']").text.should == '1'
    end
  end

  describe 'visit' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "/home?location=melbourne&location=sydney", always_encode: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home'
    end

    context "first argument" do
      it 'should match on always_encode' do
        fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[0].text.should == 'true'
      end

      it 'should match on query param name: location' do
        fragment.search(".//stringProp[@name='Argument.name']")[0].text.should == 'location'
      end

      it 'should match on query param value: melbourne' do
        fragment.search(".//stringProp[@name='Argument.value']")[0].text.should == 'melbourne'
      end
    end

    context "second argument" do
      it 'should match on always_encode' do
        fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[1].text.should == 'true'
      end

      it 'should match on query param name: location' do
        fragment.search(".//stringProp[@name='Argument.name']")[1].text.should == 'location'
      end

      it 'should match on query param value: sydney' do
        fragment.search(".//stringProp[@name='Argument.value']")[1].text.should == 'sydney'
      end
    end
  end

  describe 'visit old syntax' do
    let(:doc) do
      test do
        threads do
          visit "/home?location=melbourne", always_encode: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home'
    end
  end

  describe 'visit raw_path' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02" do
            post url: "/home?location=melbourne", raw_path: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home?location=melbourne'
    end
  end

  describe 'get_with_parameterized_domain' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "/home?location=melbourne", domain: "${custom_domain}"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home'
    end

    it 'should match on domain' do
      fragment.search(".//stringProp[@name='HTTPSampler.domain']").text.should == '${custom_domain}'
    end
  end

  describe 'https' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "https://example.com"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on protocol' do
      fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text.should == 'https'
    end
  end

  describe 'user_parameters' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02", parent: true, include_timers: true do
            visit url: "/" do
              user_parameters names: ['name1', 'name2'],
                thread_values: {
                  user_1: [
                    'value1',
                    'value2'
                  ],

                  user_2: [
                    'value1',
                    'value2'
                  ]
                }
            end
          end
        end
      end.to_doc
    end

    let(:names) { doc.search("//collectionProp[@name='UserParameters.names']").first }
    let(:thread_values) { doc.search("//collectionProp[@name='UserParameters.thread_values']").first }

    it 'should match on names' do
      names.search(".//stringProp[@name='name1']").text.should == 'name1'
      names.search(".//stringProp[@name='name2']").text.should == 'name2'
    end

    it 'should match on thread values' do
      thread_values.search(".//stringProp[@name='0']").first.text.should == 'value1'
      thread_values.search(".//stringProp[@name='1']").first.text.should == 'value2'
    end
  end

  describe 'xhr' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02", parent: true, include_timers: true do
            visit url: "/" do
              with_xhr
            end
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HeaderManager').first }

    it 'should match on XHR' do
      fragment.search(".//stringProp[@name='Header.value']").text.should == 'XMLHttpRequest'
    end
  end

  describe 'gzip' do
    let(:doc) do
      test do
        threads do
          transaction name: 'TC_02', parent: true, include_timers: true do
            visit url: '/' do
              with_gzip
            end
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HeaderManager').first }

    it 'should match on Acept Encoding' do
      fragment.search(".//stringProp[@name='Header.value']").text.should == 'gzip, deflate'
    end
  end

  describe 'submit' do
    let(:doc) do
      test do
        threads do
          transaction name: 'TC_03', parent: true, include_timers: true do
            submit url: "/", fill_in: { username: 'tim', password: 'password' }
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on POST' do
      fragment.search(".//stringProp[@name='HTTPSampler.method']").text.should == 'POST'
    end

    it 'should have no files' do
      fragment.search(".//elementProp[@name='HTTPsampler.Files']").length.should == 0
    end
  end

  describe 'submit_with_files' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_03", parent: true, include_timers: true do
            submit url: "/", fill_in: { username: 'tim', password: 'password' },
                   files: [{path: '/tmp/foo', paramname: 'fileup', mimetype: 'text/plain'},
                           {path: '/tmp/bar', paramname: 'otherfileup'}]
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy/elementProp[@name='HTTPsampler.Files']").first }

    it 'should have two files' do
      fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']").length.should == 2
    end

    it 'should have one empty mimetype' do
      fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']/stringProp[@name='File.mimetype' and normalize-space(.) = '']").length.should == 1
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

  describe 'Loop' do
    let(:doc) do
      test do
        threads do
          Loop count: 5 do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//LoopController').first }

    it 'should match on Loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '5'
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

  describe 'regex extract' do
    let(:doc) do
      test do
        extract regex: 'pattern', name: 'my_regex'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'should match on refname' do
      fragment.search(".//stringProp[@name='RegexExtractor.refname']").text.should == 'my_regex'
    end
  end

  describe 'regex extract with variable' do
    let(:doc) do
      test do
        extract regex: 'pattern', name: 'my_regex', variable: 'test'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'should match on refname' do
      fragment.search(".//stringProp[@name='Scope.variable']").text.should == 'test'
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

  describe 'testdata extract' do
    let(:doc) do
      test do
        test_data 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'should match on refname' do
      fragment.search(".//stringProp[@name='RegexExtractor.refname']").text.should == 'testdata'
    end
  end

  describe 'assertions' do
    describe 'scope all' do
      let(:doc) do
        test do
          visit '/' do
            assert contains: 'Welcome'
          end
        end.to_doc
      end

      let(:fragment) { doc.search("//ResponseAssertion").first }

      it 'should match on match' do
        fragment.search(".//stringProp[@name='0']").text.should == 'Welcome'
      end

      it 'should match on scope' do
        fragment.search(".//stringProp[@name='Assertion.scope']").text.should == 'all'
      end

      it 'should match on test_type' do
        fragment.search(".//intProp[@name='Assertion.test_type']").text.should == '2'
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

    describe 'scope variable' do
      let(:doc) do
        test do
          visit '/' do
            assert contains: 'someting', variable: 'some_jmeter_variable'
          end
        end.to_doc
      end

      let(:fragment) { doc.search("//ResponseAssertion").first }

      it 'should match on scope' do
        fragment.search(".//stringProp[@name='Assertion.scope']").text.should == "variable"
      end

      it 'should match on variable' do
        fragment.search(".//stringProp[@name='Scope.variable']").text.should == "some_jmeter_variable"
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

  describe 'module controllers' do
    let(:doc) do
      test name: 'tests' do
        threads 1, name: 'threads' do
          Simple name: 'controller_to_call'
        end
        threads 1 do
          module_controller name: 'modules', node_path: [
            'WorkBench',
            'tests',
            'threads',
            'controller_to_call'
          ]
        end
      end.to_doc
    end

    let(:simple_controller) { doc.search("//GenericController").first }
    let(:test_module) { doc.search("//ModuleController").first }
    let(:nodes) { test_module.search(".//stringProp") }

    it 'should have a node path' do
      nodes.length.should == 4
      nodes[0].text.should == 'WorkBench'
      nodes[1].text.should == 'tests'
      nodes[2].text.should == 'threads'
      nodes[3].text.should == 'controller_to_call'
    end
  end

  describe 'module controllers with test fragment' do
    let(:doc) do
      test do
        test_fragment name: 'some_test_fragment', enabled: 'false' do
          get name: 'Home Page', url: 'http://google.com'
        end

        threads count: 1 do
          module_controller test_fragment: 'WorkBench/TestPlan/some_test_fragment'
        end
      end.to_doc
    end

    let(:simple_controller) { doc.search("//GenericController").first }
    let(:test_module) { doc.search("//ModuleController").first }
    let(:nodes) { test_module.search(".//stringProp") }

    it 'should have a node path specified by test fragment' do
      nodes.length.should == 3
      nodes[0].text.should == 'WorkBench'
      nodes[1].text.should == 'TestPlan'
      nodes[2].text.should == 'some_test_fragment'
    end
  end

  describe 'dummy sampler' do
    let(:doc) do
      test do
        threads do
          dummy_sampler 'dummy sampler name', { RESPONSE_DATA: "Some response data" }
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//kg.apc.jmeter.samplers.DummySampler").first }

    it 'should match on name' do
      fragment.attributes['testname'].value.should == 'dummy sampler name'
    end

    it 'should match on response data' do
      fragment.search("//stringProp[@name='RESPONSE_DATA']").text.should == 'Some response data'
    end
  end

  describe 'perfmon collector' do
    let(:doc) do
      test do
        threads do
          perfmon_collector 'perfmon collector name',
          [
            {server: '1.1.1.1', port: 4444, metric: 'CPU', parameters: ''},
            {server: '2.2.2.2', port: 4444, metric: 'CPU', parameters: ''}
          ],
          "perf.jtl",
          false
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//kg.apc.jmeter.perfmon.PerfMonCollector").first }
    let(:metric_connections) { fragment.search("//collectionProp[@name='metricConnections']").first }

    it 'should match on name' do
      fragment.attributes['testname'].value.should == 'perfmon collector name'
    end

    it 'should match on xml flag' do
      fragment.search(".//xml").first.text.should == 'false'
    end

    it 'should match on first server ip' do
      metric_connections.search("//stringProp[@name='']").first.text.should == '1.1.1.1'
    end
  end
end
