require 'twelite_serial_data'

sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  begin
    line = sp.gets # read
    data = TweliteSerialData.new(line.strip)
    puts data[:analog_in1]
  rescue => e
    puts e.to_s
  end
end
