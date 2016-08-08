module RubyJmeter
  class ExtendedDSL < DSL
    def response_codes_per_second(name = 'Response Codes per Second', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseCodesPerSecond.new(name, params)
      attach_node(node, &block)
    end

    def response_times_distribution(name = 'Response Times Distribution', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesDistribution.new(name, params)
      attach_node(node, &block)
    end

    def response_times_over_time(name = 'Response Times Over Time', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesOverTime.new(name, params)
      attach_node(node, &block)
    end

    def response_times_percentiles(name = 'Response Times Percentiles', params = {}, &block)
      node = RubyJmeter::Plugins::ResponseTimesPercentiles.new(name, params)
      attach_node(node, &block)
    end

    def transactions_per_second(name = 'Transactions per Second', params = {}, &block)
      node = RubyJmeter::Plugins::TransactionsPerSecond.new(name, params)
      attach_node(node, &block)
    end

    def latencies_over_time(name = 'Response Latencies Over Time', params = {}, &block)
      node = RubyJmeter::Plugins::LatenciesOverTime.new(name, params)
      attach_node(node, &block)
    end

    def console_status_logger(name = 'Console Status Logger', params = {}, &block)
      node = RubyJmeter::Plugins::ConsoleStatusLogger.new(name, params)
      attach_node(node, &block)
    end

    alias console console_status_logger

    def throughput_shaper(name = 'Throughput Shaping Timer', steps=[], params = {}, &block)
      node = RubyJmeter::Plugins::ThroughputShapingTimer.new(name, steps)
      attach_node(node, &block)
    end

    alias shaper throughput_shaper

    def dummy_sampler(name = 'Dummy Sampler', params = {}, &block)
      node = RubyJmeter::Plugins::DummySampler.new(name, params)
      attach_node(node, &block)
    end

    alias dummy dummy_sampler

    def stepping_thread_group(params = {}, &block)
      node = RubyJmeter::Plugins::SteppingThreadGroup.new(params)
      attach_node(node, &block)
    end

    alias step stepping_thread_group

    def ultimate_thread_group(threads = [], params = {}, &block)
      node = RubyJmeter::Plugins::UltimateThreadGroup.new(params)

      threads.each_with_index do |group, index|
        node.doc.at_xpath('//collectionProp') <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <collectionProp name="index">
              <stringProp name="#{group[:start_threads]}">#{group[:start_threads]}</stringProp>
              <stringProp name="#{group[:initial_delay]}">#{group[:initial_delay]}</stringProp>
              <stringProp name="#{group[:start_time]}">#{group[:start_time]}</stringProp>
              <stringProp name="#{group[:hold_time]}">#{group[:hold_time]}</stringProp>
              <stringProp name="#{group[:stop_time]}">#{group[:stop_time]}</stringProp>
            </collectionProp>
          EOS
      end

      attach_node(node, &block)
    end

    alias ultimate ultimate_thread_group

    def composite_graph(name, params = {}, &block)
      node = RubyJmeter::Plugins::CompositeGraph.new(name, params)
      attach_node(node, &block)
    end

    alias composite composite_graph

    def active_threads_over_time(params = {}, &block)
      node = RubyJmeter::Plugins::ActiveThreadsOverTime.new(params)
      attach_node(node, &block)
    end

    alias active_threads active_threads_over_time

    def perfmon_collector(params = {}, &block)
      node = RubyJmeter::Plugins::PerfmonCollector.new(params)
      attach_node(node, &block)
    end

    alias perfmon perfmon_collector

    def loadosophia_uploader(name = "Loadosophia.org Uploader", params = {}, &block)
      node = RubyJmeter::Plugins::LoadosophiaUploader.new(name, params)
      attach_node(node, &block)
    end

    alias loadosophia loadosophia_uploader

    def redis_data_set(params = {}, &block)
      node = RubyJmeter::Plugins::RedisDataSet.new(params)
      attach_node(node, &block)
    end
  end
end
