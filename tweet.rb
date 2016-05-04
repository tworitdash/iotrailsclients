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
		token = {
			:token => "",
			:tweet => "Dharmasish "
			
		}
		req = EM::HttpRequest.new('http://localhost:3000/api/tweet.json').get(query: token)
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