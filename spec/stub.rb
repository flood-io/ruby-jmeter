require 'sinatra'

get '/' do
  haml :index
end

post '/login' do
  logger.info params
  haml :index
end

get '/cookies' do
  response.set_cookie("JSESSIONID", :value => "1337")
end

get '/magic' do
  haml :magic
end

__END__

@@ layout
%html
  %meta(content="XAWfTfoqH9eOQy4ZN1U4z+rzfnC/hihb5lWv4VLRY5g=" name="csrf-token")
  = yield

@@ index
%div.title Hello world.

@@ magic
%div.title Magic happens