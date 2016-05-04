require "eventmachine"
require "em-websocket"
require "evma_httpserver"
require "em-http-request"
require "nokogiri"
require "json"
require "pp"
require "serialport"



class Register
	include EM::Deferrable
	def initialize()
		@rfid = SerialPort.new("/dev/tty.usbserial-A90246LK", 9600)
	end
	def read()
		#regex = /^[A-Z0-9]{10}$/
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
	def register(tag)
		token = {
			:token => "your_id",
			:tag => tag
		}
		req = EM::HttpRequest.new('https://secret-garden-18195.herokuapp.com/api/register_card.json').get(query: token)
		#req = EM::HttpRequest.new('tcp://localhost:3000/api/register_card.json').get(query: query)
		req.callback do
			res = JSON.parse(req.response)
			succeed(res)
		end
		req.errback { fail }
	end
end

EM.run do
		register = Register.new
		card = register.read
		register.register(card[:id])
	 	register.callback do |res|
			puts "#{res}"
			puts "success"
		end
		register.errback do 
			puts "failure"
		end
	
end