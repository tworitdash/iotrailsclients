require "rubygems"
require "eventmachine"

class EchoServer < EM::Connection
	def post_init
		puts "Client Connecting" 
	end
	def unbind 
		puts "client disconnecting"
	end
	def receive_data(data)
		puts "received #{data} from client"
		send_data ">> #{data}"
	end
end

EM.run do
	EM.start_server('0.0.0.0', 9000, EchoServer)
	puts "Server is Running on Port *9000" 
end