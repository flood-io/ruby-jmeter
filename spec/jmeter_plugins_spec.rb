require 'spec_helper'

describe 'stepping thread group' do
  let(:doc) do
    test do
      stepping_thread_group on_sample_error: 'startnextloop', total_threads: 100, initial_delay: 1, start_threads: 2, add_threads: 3, start_every: 4, stop_threads: 5, stop_every: 6, flight_time: 7, rampup: 8
    end.to_doc
  end

  let(:fragment) { doc.search("//kg.apc.jmeter.threads.SteppingThreadGroup").first }
  it 'should match on on_sample_error' do
    expect(fragment.search(".//stringProp[@name='ThreadGroup.on_sample_error']").text).to eq 'startnextloop'
  end

  it 'should match on total_threads' do
    expect(fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text).to eq '100'
  end

  it 'should match on initial_delay' do
    expect(fragment.search(".//stringProp[@name='Threads initial delay']").text).to eq '1'
  end

  it 'should match on start_threads' do
    expect(fragment.search(".//stringProp[@name='Start users count']").text).to eq '2'
  end

  it 'should match on add_threads' do
    expect(fragment.search(".//stringProp[@name='Start users count burst']").text).to eq '3'
  end

  it 'should match on start_every' do
    expect(fragment.search(".//stringProp[@name='Start users period']").text).to eq '4'
  end

  it 'should match on stop_threads' do
    expect(fragment.search(".//stringProp[@name='Stop users count']").text).to eq '5'
  end

  it 'should match on stop_every' do
    expect(fragment.search(".//stringProp[@name='Stop users period']").text).to eq '6'
  end

  it 'should match on flight_time' do
    expect(fragment.search(".//stringProp[@name='flighttime']").text).to eq '7'
  end

  it 'should match on rampup' do
    expect(fragment.search(".//stringProp[@name='rampUp']").text).to eq '8'
  end
end

describe 'dummy sampler' do
  let(:doc) do
    test do
      threads do
        dummy_sampler name: 'dummy sampler name', response_data: 'Some response data'
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//kg.apc.jmeter.samplers.DummySampler").first }

  it 'should match on name' do
    expect(fragment.attributes['testname'].value).to eq 'dummy sampler name'
  end

  it 'should match on response data' do
    expect(fragment.search("//stringProp[@name='RESPONSE_DATA']").text).to eq 'Some response data'
  end
end

describe 'perfmon collector' do
  let(:doc) do
    test do
      threads do
        perfmon_collector name: 'perfmon collector name',
        nodes:
          [
            {server: '1.1.1.1', port: 4444, metric: 'CPU', parameters: ''},
            {server: '2.2.2.2', port: 4444, metric: 'CPU', parameters: ''}
          ],
        filename: 'perf.jtl',
        xml: false
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//kg.apc.jmeter.perfmon.PerfMonCollector").first }
  let(:metric_connections) { fragment.search("//collectionProp[@name='metricConnections']").first }

  it 'should match on name' do
    expect(fragment.attributes['testname'].value).to eq 'perfmon collector name'
  end

  it 'should match on xml flag' do
    expect(fragment.search(".//xml").first.text).to eq 'false'
  end

  it 'should match on first server ip' do
    expect(metric_connections.search("//stringProp[@name='']").first.text).to eq '1.1.1.1'
  end
end

describe 'redis data set' do
  describe 'random keep' do
    let(:doc) do
      test do
        threads do
          redis_data_set name: 'redis data set name',
            host: 'the_host',
            port: 1234

        end
      end.to_doc
    end

    let(:fragment) { doc.search("//kg.apc.jmeter.config.redis.RedisDataSet").first }

    it 'should have a name' do
      expect(fragment.attributes['testname'].value).to eq 'redis data set name'
    end

    it 'should be configured for random keep' do
      expect(fragment.search("//intProp[@name='getMode']").text).to eq '1'
    end

    it 'should point to the host' do
      expect(fragment.search("//stringProp[@name='host']").text).to eq 'the_host'
    end

    it 'should configure a port' do
      expect(fragment.search("//stringProp[@name='port']").text).to eq '1234'
    end
  end

  describe 'random remove' do
    let(:doc) do
      test do
        threads do
          redis_data_set remove: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//kg.apc.jmeter.config.redis.RedisDataSet").first }

    it 'should have a default name' do
      expect(fragment.attributes['testname'].value).to eq 'Redis Data Set Config'
    end

    it 'should be configured for random remove' do
      expect(fragment.search("//intProp[@name='getMode']").text).to eq '0'
    end
  end
end

describe 'jmx collector' do

  describe 'passing all optionals' do
    let(:doc) do
      test do
        jmx_collector(
            name: 'some jmx collector name',
            host: 'localhost',
            port: 12345,
            object_name: 'java.lang:type=Memory',
            attribute_name: 'HeapMemoryUsage',
            attribute_key: 'committed',
            jtl: 'path/to/some/dir/file.jtl'
        )
      end.to_doc
    end

    let(:fragment) {
      doc.search('//kg.apc.jmeter.jmxmon.JMXMonCollector').first }

    it 'should have a name' do
      expect(fragment.attributes['testname'].value).to eq 'some jmx collector name'
    end

    it 'should point to the service endpoint' do
      expect(fragment.search("//stringProp[@name='service_endpoint']").text).to eq 'service:jmx:rmi:///jndi/rmi://localhost:12345/jmxrmi'
    end

    it 'should use the object name' do
      expect(fragment.search("//stringProp[@name='object_name']").text).to eq 'java.lang:type=Memory'
    end

    it 'should use the attribute name' do
      expect(fragment.search("//stringProp[@name='attribute_name']").text).to eq 'HeapMemoryUsage'
    end

    it 'should use the attribute key' do
      expect(fragment.search("//stringProp[@name='attribute_key']").text).to eq 'committed'
    end

    it 'should use the jtl path' do
      expect(fragment.search("//stringProp[@name='filename']").text).to eq 'path/to/some/dir/file.jtl'
    end

  end

  describe 'passing no optionals' do
    let(:doc) do
      test do
        jmx_collector(
            host: '127.0.0.1',
            port: 54321,
            object_name: 'java.lang:type=Threading',
            attribute_name: 'ThreadCount',
        )
      end.to_doc
    end

    let(:fragment) {
      doc.search('//kg.apc.jmeter.jmxmon.JMXMonCollector').first }

    it 'should have a default name' do
      expect(fragment.attributes['testname'].value).to eq 'JMX Collector'
    end

    it 'should point to the service endpoint' do
      expect(fragment.search("//stringProp[@name='service_endpoint']").text).to eq 'service:jmx:rmi:///jndi/rmi://127.0.0.1:54321/jmxrmi'
    end

    it 'should use the object name' do
      expect(fragment.search("//stringProp[@name='object_name']").text).to eq 'java.lang:type=Threading'
    end

    it 'should use the attribute name' do
      expect(fragment.search("//stringProp[@name='attribute_name']").text).to eq 'ThreadCount'
    end

    it 'should use an empty attribute key' do
      expect(fragment.search("//stringProp[@name='attribute_key']").text).to eq ''
    end

    it 'should use an empty jtl path' do
      expect(fragment.search("//stringProp[@name='filename']").text).to eq ''
    end

  end

end

