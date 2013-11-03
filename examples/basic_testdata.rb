$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads 1 do

    # populate ${testdata} array with *all* results from shared data url
    # using default match number -1
    test_data :postcodes

    # testdata now populated with:
    #testdata_1=NSW
    #testdata_1_g=1
    #testdata_1_g0="NSW"
    #testdata_1_g1=NSW
    #testdata_2=nsw-sydney-2000
    #testdata_2_g=1
    #testdata_2_g0="nsw-sydney-2000"
    #testdata_2_g1=nsw-sydney-2000
    #testdata_matchNr=2

    # visit first column match
    visit 'http://example.com/?${testdata_1}'

    # visit second column match
    visit 'http://example.com/?${testdata_2}'

    # populate named ${postcodes} array  with all results from shared data url
    # using specific key, command and host
    test_data key: 'postcodes',
      command: 'SRANDMEMBER',
      host: '54.252.206.143'

    # populate named ${postcode_random} from shared data url
    # using random result, match number 0 and override name
    test_data :postcodes, 
      name: 'postcode_random', 
      match_num: 0


    # populate named ${postcode} from shared data url
    # using exact result, match number 1 and override name
    test_data 'postcodes', 
      name: 'postcode_exact', 
      regex: '^(\d+)', 
      match_num: 1

    # populate named ${postcode} from a stubbed data url
    # with stub = true and default value 2010
    test_data 'postcodes', 
      name: 'postcode_stub', 
      regex: '^(\d+)', 
      match_num: 1, 
      default: '2010', 
      stub: true

    debug_sampler
    view_results
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
