require './twelite_serial_data'
require './wc'
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'logger'
require 'mqtt'
require 'json'

log = Logger.new('/tmp/wc_log.txt')

sp = SerialPort.new('/dev/ttyUSB0', 115_200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none

@client = MQTT::Client.connect(host: 'a1f18lql3l5z0z.iot.ap-northeast-1.amazonaws.com',
                               port: 8883,
                               ssl: true,
                               cert_file: 'cert.pem',
                               key_file: 'private-key.pem',
                               ca_file: 'rootCA.pem')

wc = Wc.new

loop do
  begin
    line = sp.gets # read
    data = TweliteSerialData.new(line.strip)
    wc.add(data) do |x, v|
      log.info "event value = #{x}, value = #{v}"
      value_map = {
        1 => 'IN',
        -1 => 'OUT'
      }
      next if value_map[x].nil?
      status = {
        state: {
          reported: {
            status: value_map[x]
          }
        }
      }
      @client.publish(
        '$aws/things/wc-sensor/shadow/update',
        status.to_json
      )
    end
    log.info data[:analog_in1]
    log.info data.original
  rescue => e
    log.fatal e.to_s
  end
end
