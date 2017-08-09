require './twelite_serial_data'
require './wc'
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'logger'

log = Logger.new('/tmp/wc_log.txt')

sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
wc = Wc.new
loop do
  begin
    line = sp.gets # read
    data = TweliteSerialData.new(line.strip)
    wc.add(data) do |x, v|
      puts x, v
    end
    # log.info data[:analog_in1]
    # log.info data.original
  rescue => e
    log.fatal "[ERROR] #{e.to_s}"
  end
end
