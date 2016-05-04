require 'rubygems'
require 'eventmachine'

class EchoClient < EM::Connection
	def initialize(user)
		@user = user
	end
	def post_init
		puts "connected"
		send_data "Hello From #{@user}"
	end
	def unbind
		puts "disconnected"
	end
	def receive_data(data)
		puts "received #{data}"
	end
end

EM.run do
	EM.connect('localhost', 8080, EchoClient, ARGV[0])
end