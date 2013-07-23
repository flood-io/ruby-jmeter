module RubyJmeter
  class UserAgent
    def initialize(device)
      @common_devices = {
        :iphone     => 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3',
        :ipod       => 'Mozilla/5.0 (iPod; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3',
        :ipad       => 'Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3',
        :safari_osx => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.25 (KHTML, like Gecko) Version/6.0 Safari/536.25',
        :safari_win => 'Mozilla/5.0 (Windows; Windows NT 6.1) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2',
        :ie7        => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)',
        :ie8        => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)',
        :ie9        => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)',
        :chrome_osx => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5',
        :chrome_win => 'Mozilla/5.0 (Windows; Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5',
        :ff_osx     => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20100101 Firefox/11.0',
        :ff_win     => 'Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20100101 Firefox/11.0',
        :opera_osx  => 'Opera/9.80 (Macintosh; Intel Mac OS X 10.7.4; U; en) Presto/2.10.229 Version/11.62',
        :opera_win  => 'Opera/9.80 (Windows NT 6.1; U; en) Presto/2.10.229 Version/11.62'
      }
      @device = device
    end

    def string
      @common_devices[@device] || @common_devices[:chrome_osx]
    end
  end
end
