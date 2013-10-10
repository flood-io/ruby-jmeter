$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'
require 'recursive-open-struct'
require 'json'
require 'pry-debugger'

har = RecursiveOpenStruct.new(JSON.parse(File.open('basic_har.json').read), recurse_over_arrays: true)

test do
  cache

  cookies

  header [ 
    { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
    { name: 'Accept', value: 'text/javascript, text/html, application/xml, text/xml, */*' }
  ]

  threads count: 1 do

    har.log.entries.collect {|entry| entry.pageref }.uniq.each do |page|

      transaction name: page do
        har.log.entries.select {|request| request.pageref == page }.each do |entry|
          next unless entry.request.url =~ /http/
          params = entry.request.postData && entry.request.postData.params.collect {|param| [param.name, param.value] }.flatten
          self.send entry.request.to_h.values.first.downcase, entry.request.url, fill_in: Hash[*params] do
            with_xhr if entry.request.headers.to_s =~ /XMLHttpRequest/
          end
        end
      end
    end
  end
end.out
