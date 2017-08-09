require './twelite_serial_data'
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'logger'

log = Logger.new('/tmp/wc_log.txt')

sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  begin
    line = sp.gets # read
    data = TweliteSerialData.new(line.strip)
    log.fatal data[:analog_in1]
    # puts data[:voltage]
    #puts data[:quality]
    log.fatal data.original
    log.fatal Time.now
  rescue => e
    log.fatal "[ERROR] #{e.to_s}"
  end
end
