# Changes

## v2.1.5

- HTTP Request Defaults now have more intuitive key names:

```ruby
defaults domain: 'example.com', 
      protocol: 'https',
      download_resources: true,
      use_concurrent_pool: 5,
      urls_must_match: 'http.+?example.com'
```

- There's a new `with_gzip` header manager alias:

```ruby
test do
  threads do
    transaction name: "TC_02", parent: true, include_timers: true do
      visit url: "/" do
        with_gzip
      end
    end
  end
end
```

- There's a new `test_data` helper method to simplify getting test data from the flood.io shared data URL. Including ability to stub, set defaults, get all values or explicit values :

```ruby
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
```
