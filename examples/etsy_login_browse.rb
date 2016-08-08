$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  defaults :domain => 'www.etsy.com'

  cache :clear_each_iteration => true

  cookies

  threads :count => 1, :loops => 10 do

    random_timer 1000, 3000

    transaction '01_etsy_home' do
      visit :name => 'home', :url => 'http://www.etsy.com/' do
        assert 'contains' => 'Etsy - Your place to buy and sell all things handmade, vintage, and supplies'
      end
    end

    Once do
      transaction '02_etsy_signin' do
        submit :name => 'signin', :url => 'https://www.etsy.com/signin',
          :fill_in => {
            :username    => 'tim.koops@gmail.com',
            :password    => ARGV[0],
            :persistent  => 1,
            :from_page   => 'http://www.etsy.com/',
            :from_action => '',
            :from_name   => '',
            :overlay     => 1
          } do
            assert 'contains' => 'Tim'
            extract :regex => 'a href="(/browse.+?)"', :name => 'random_category'
        end
      end
    end

    exists 'random_category' do

      transaction '03_etsy_browse_random_category' do
        visit :name => 'browse', :url => '${random_category}' do
          extract :regex => 'a href="(http.+?subcat.+?)"', :name => 'random_sub_category'
        end
      end

      transaction '04_etsy_browse_random_sub_category' do
        visit :name => 'browse', :url => '${random_sub_category}' do
          extract :regex => 'a href="(/listing.+?)"', :name => 'random_listing'
        end
      end

      transaction '05_etsy_view_random_listing' do
        visit :name => 'view', :url => '${random_listing}'
      end

    end

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
