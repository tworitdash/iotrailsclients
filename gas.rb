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
		@gas = SerialPort.new("/dev/tty.usbmodem1411", 9600)
		@gas.read_timeout = 1000
	end
	def read()
		#while true do
			id = @gas.gets.to_s
			puts id
			gas_status = id.split("\r\n")
			if gas_status 
				
					gas_value = {:name => "Gas Sensor !", :id => gas_status[0].to_s}
					return gas_value
					#@gas.close
				
			end
		#end
	end

	
	def check_value_and_tweet(value)
		tag = {
			#:token => "Dsm4m4SRjQvUX-O0cJbY9Q",
			:token => "your_id",
			:value => value,
			:tweet => "This is my gas sensor tweeting ! The value is #{value}:D "
		}
		#req = EM::HttpRequest.new('https://secret-garden-18195.herokuapp.com/api/gas_alert.json').get(query: tag)
		req = EM::HttpRequest.new('http://localhost:3000/api/gas_alert.json').get(query: tag)
		req.callback do
			res = JSON.parse(req.response)
			succeed(res)
		end
		req.errback { fail }
	end
end



EM.run do
	
		tweet = Tweet.new
		#while true
		EM.add_periodic_timer(4) do 
			gas_value = tweet.read
		
			#EM.add_timer(3) do 
				if gas_value[:id].to_i > 220
					tweet.check_value_and_tweet(gas_value[:id])
					tweet.callback do |res|
						puts "#{res}"
						puts "success"
					end
					tweet.errback do
						puts "Mailed"
					end
				end
			#end
		end

			#sleep 4
		#end
	
end