require "eventmachine"
require "em-websocket"
require "evma_httpserver"
require "em-http-request"
require "nokogiri"
require "json"
require "pp"
require "serialport"


class Tweet
  include EM::Deferrable

  def query()
    message = {
      :token => "your_id",
      :data => "I am Tworit",
      :channel => "/chat/new"
      
    }
    req = EM::HttpRequest.new('http://localhost:9292/faye').get(query: message)
    #puts req
    # msg = JSON.parse(req.response)
    # pus msg
    #req = EM::HttpRequest.new('https://secret-garden-18195.herokuapp.com/api/tweet.json').get(query: token)
    req.callback do 
      msg = JSON.parse(req.response)
      
      succeed(msg) 
    end
    req.errback { fail }

  end
  
end



EM.run do
    
    tweet = Tweet.new
      
    tweet.query
    tweet.callback do |msg|
      puts "#{msg}"
      puts "success"
    end
    tweet.errback do
      puts "Failed to tweet"
    end
        
      
    
end