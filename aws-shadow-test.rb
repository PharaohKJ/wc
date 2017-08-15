# coding: utf-8
require 'logger'
require 'mqtt'

require 'json'

log = Logger.new('/tmp/wc_log.txt')

@client = MQTT::Client.connect(host: 'a1f18lql3l5z0z.iot.ap-northeast-1.amazonaws.com',
                               port: 8883,
                               ssl: true,
                               cert_file: 'cert.pem',
                               key_file: 'private-key.pem',
                               ca_file: 'rootCA.pem')

test_hash = {
  state: {
    desired: nil,
    reported: {
      status: "OUT"
    }
  },
  versiosn: 7
}

# reported : thing からレポートするものが指定
# or
# desired  : thing をコントロールするものが指定
# desired で指定されると、その差分は delta で取得できる
# それの version を見て、それと同じ version を指定した repoted で値を上書きすれば
# 状況は更新される

#loop do
  begin
    @client.publish('$aws/things/wc-sensor/shadow/update', test_hash.to_json)
  rescue => e
    log.info e
  end
#end
