################################################################################
# This is an example of how to use a Redis data set with CSV data.
# The test plan defines a setup thread group with a JSR223 sampler (scripted in
# Groovy), which pre-populates Redis with the data used for the actual test.
# The test itself simply calls a REST API with data seeded from Redis.
#
# The redis key is "test_data" and the format of the CSV data is:
#   user_id,start_date,end_date
#
# Requires:
#  JMeter (recommended version: 2.13 or later)
#  jmeter-plugins extras with libs (this gives us the redis data set config)
#  Groovy 2.4 or later (put the groovy-all jar into $JMETER_HOME/lib)
################################################################################

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

# For redis dataset config.
redis_host = 'localhost'
redis_port = 6379
redis_key = 'test_data'
num_records = 1000 # how many rows of test data to generate

# for HTTP request defaults
protocol = 'http'
host = 'localhost'
port = 8080

# JMeter test plan begins here.
test do

  # Setup the data set we will use to run the tests.
  setup_thread_group name: 'Redis Fill',
    loops: 1 do
    jsr223_sampler name: 'redis fill',
      scriptLanguage: 'groovy',
      cacheKey: 'prefill_user_ids',
      script: <<-EOS.strip_heredoc
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.Jedis;

import java.util.Random;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

JedisPoolConfig config = new JedisPoolConfig();
JedisPool pool = new JedisPool(config, "#{redis_host}", #{redis_port});
Jedis jedis = null;
try {
    jedis = pool.getResource();

    //delete old data, if it exists
    jedis.del("#{redis_key}");

    // Create a list of the last 90 days. We will seed our test data from this.
    Date now = new Date();
    Date oldest = now - 90;
    Range days = oldest..now;

    Random random = new Random();
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    /*
     * Generate CSV data in the form of:
     *   user_id,start_date,end_date
     */
    for (int i = 1; i <= #{num_records}; i++) {
        Date day = days[random.nextInt(days.size())]
        String data = [i, df.format(day), df.format(day)].join(',')
        jedis.sadd("#{redis_key}", data);
    }
}finally {
    if(jedis != null) {
        pool.returnResource(jedis);
    }
}
        EOS
  end

  # Defines a thread group. We allow certain parameters to be passed in
  # as system properties.
  threads name: 'Test Scenario - REST API query',
    count: '${__P(threads,1)}',
    rampup: '${__P(rampup,600)}',
    duration: '${__P(duration, 600)}' do

    # HTTP request defaults
    defaults domain: host, # default domain if not specified in URL
      protocol: protocol, # default protocol if not specified in URL
      port: port,
      download_resources: false # download images/CSS/JS (no)

    cookies # om nom nom

    cache clear_each_iteration: true # each thread iteration mimics a new user with an empty browser cache

    with_gzip # add HTTP request headers to allow GZIP compression. Most sites support this nowadays.

    # Test data. Note how the variableNames match the variables used by the
    # sampler below.
    redis_data_set 'test data',
      redisKey: redis_key,
      host: redis_host,
      port: redis_port,
      variableNames: 'user_id,start_date,end_date'

    # User workflow begins here.
    visit name: 'REST API query',
      url: '/rest/query',
      always_encode: true,
      fill_in: {
        'user_id' => '${user_id}',
        'start' => '${start_date}',
        'end' => '${end_date}'
      }
  end

  response_time_graph
  view_results_tree
end.jmx(file: 'real_redis_data_set_with_setup.jmx')
