$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads 1 do

    # populate ${testdata} array with all results from shared data url
    test_data 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text'

    # populate named ${postcodes} array  with all results from shared data url
    test_data url: 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text',
              name: 'postcodes'

    # populate named ${postcode} with random result from shared data url
    test_data url: 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text',
              name: 'postcode_random', match_num: 0


    # populate named ${postcode} with exact match from shared data url
    test_data url: 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text',
              name: 'postcode_exact', regex: '^(\d+)', match_num: 1

    # populate named ${postcode} with exact match from a stubbed data url
    test_data url: 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text',
              name: 'postcode_stub', regex: '^(\d+)', match_num: 1, default: '2010', stub: true

    debug_sampler
    view_results
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
