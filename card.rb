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
	def initialize()
		@rfid = SerialPort.new("/dev/tty.usbserial-A90246LK", 9600)
	end
	def read()
		while true do
			id = @rfid.gets.to_s
			card = id.split("\r\n")
			if card
				if card[0].to_s.bytesize == 10
					card_id = {:name => "RFID", :id => card[0].to_s}
					return card_id
					@rfid.close
				else 
					puts "match failed"
				end
			end
		end
	end

	
	def check_tag_and_tweet(tag_id)
		tag = {
			:token => "your_id",
			:tag => tag_id,
			:tweet => "This is my gas sensor tweeting :D"
		}
		req = EM::HttpRequest.new('https://secret-garden-18195.herokuapp.com/api/check_tag.json').get(query: tag)
		#req = EM::HttpRequest.new('http://localhost:3000/api/check_tag.json').get(query: tag)
		req.callback do
			res = JSON.parse(req.response)
			succeed(res)
		end
		req.errback { fail }
	end
end



EM.run do
	tweet = Tweet.new
	#while 1
		card = tweet.read
		tweet.check_tag_and_tweet(card[:id])
		tweet.callback do |res|
			puts "#{res}"
			puts "success"
		end
		tweet.errback do
			puts "failed"
		end
	#end
end