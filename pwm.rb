require "rubygems"
require "arduino_firmata"

arduino = ArduinoFirmata.connect

0.upto(255) do |i|
  arduino.analog_write 9, i  # <= 0 ~ 255
  sleep 0.01
end