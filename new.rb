require 'eventmachine'
require 'em-websocket'
require 'evma_httpserver'

class HTTPServer < EventMachine::Connection
    include EventMachine::HttpServer

    def initialize(msg)
        @msg = msg
    end

    def process_http_request
        response = EventMachine::DelegatedHttpResponse.new(self)
        response.status = 200
        response.content = @msg
        response.content_type "text/plain"
        response.send_response
    end
end


EM.run do

    @clients = []

    EM::WebSocket.start(:host => '0.0.0.0', :port => '9000') do |ws|
        puts "Websocket Server Listens to *9000"
        ws.onopen do |handshake|
            @clients << ws
            ws.send "Connected to #{handshake.path}."
            puts "Connected"
        end

        ws.onclose do
            ws.send "Closed."
            puts "closed"
            @clients.delete ws
        end

        ws.onmessage do |msg|
            puts "Received Message: #{msg}"
            EM.start_server '0.0.0.0', 8080, HTTPServer, msg
            puts "HTTPServer Listens to *8080"
            #HTTPServer::process_http_request(msg)
            @clients.each do |socket|
                socket.send msg
            end
        end
    end

end
