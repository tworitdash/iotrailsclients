require_relative 'em-websocket-client'
require "serialport"
require "json"
require "arduino_firmata"

arduino = ArduinoFirmata.connect
arduino.digital_write 10, true
arduino.digital_write 11, false

REGEX = /(light|fan) (?:(true|false)|(\d+))/

#rfid = SerialPort.new("/dev/tty.usbserial-A90246LK", 9600)
#rfid.read_timeout = 1000

EM.run do
    conn = EventMachine::WebSocketClient.connect("ws://localhost:8000/")
    #conn = EventMachine::WebSocketClient.connect("ws://0.0.0.0:8000/")
    conn.callback do
        conn.send_msg "connected ! "
       # while true do 
           

        ###
    end

    conn.errback do |e|
        puts "Got error: #{e}"
    end

    conn.stream do |msg|
    	#puts msg.inspect
    	res = msg.to_s
        if (REGEX =~ res) != nil
            device = Regexp.last_match(1)
            boolean = Regexp.last_match(2)
            value = Regexp.last_match(3)
            puts  value

            if value 
                arduino.analog_write 9, value.to_i
                puts "Sent value"
            end

        end


    	
    	# port_file = "/dev/cu.usbmodem1421"
     #    baud_rate = 9600
     #    data_bits = 8
     #    stop_bits = 1
     #    parity = SerialPort::NONE
     #    ser = SerialPort.new(port_file , baud_rate , data_bits , stop_bits , parity)
     #    ser.write("#{msg}")
        # if msg == 'f'
        #     puts "Blinking for 2 seconds !"
        # end
        # if msg == 'l'
        #     puts "Blinking for 0.5 seconds !"
        # end
        # if msg == 'r'
        #     puts "Blinking permanently !"
        # end
        # if msg == 'b'
        #     puts "Stop Blinking !"
        # end
		#puts "registering..."
		#v_db.store("card#{msg}", {"id" => msg, "number" => "#{msg}"})
		#file.write(v_db.to_json)
		#puts "registered :) your RFID card has been registered and can be accessed by the reader !"	
     end

     

    conn.disconnect do
        puts "disconnected!"
        EM::stop_event_loop
    end
end
