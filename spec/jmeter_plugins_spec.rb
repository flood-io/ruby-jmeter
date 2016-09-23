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
