$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  
  defaults  domain: 'www.immi.gov.au', 
            protocol: 'http', 
            image_parser: true,
            concurrentDwn: true,
            concurrentPool: 4

  cache

  cookies

  with_user_agent :iphone

  header [ 
    { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
    { name: 'Accept', value: 'text/javascript, text/html, application/xml, text/xml, */*' }
  ]
  
  threads 1, {
    rampup: 1, 
    scheduler: true,
    duration: 300, 
    continue_forever: true
    } do

    random_timer 1000, 5000

    transaction 'visa_wizard' do
      visit '/visawizard' do
        extract xpath: "//select[@id='Q1']/option/@value", name: 'q1', tolerant: true
      end
    end
    # ${__Random(1,${q1_matchNr},n)} 
    # $__V{q1_${n}}
    # $__V{q1_${${__Random(1,${q1_matchNr},)}}}


    debug_sampler

    transaction 'visa_questions' do
      # get '/ecp_new/assess/get?Q1=TRA&Q2=UK&Q3=38&Q4=TRAN&Q5=UK' do
      #   with_xhr
      #   assert contains: 'p,'
      #   extract regex: '(INF\d+)', name: 'answer'
      # end
      get '/ecp_new/assess/get',
        fill_in: {
          'Q1' => '${q1_2}',
          'Q2' => 'UK',
          'Q3' => '38',
          'Q4' => 'TRAN',
          'Q5' => 'UK'
          } do
          with_xhr
          assert contains: 'p,'
          extract regex: '(INF\d+)', name: 'answer'
      end
    end

    transaction 'visa_answer' do
      get '/visawizard/inf/${answer}'
    end

    view_results

    log filename: '/var/log/flood/custom.log', error_logging: true 

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
# end.jmx
# end.flood ENV['FLOOD_API_TOKEN'], {
#   region: 'ap-southeast-2',
#   name: 'Demo for Immi'
# }
