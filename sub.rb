# coding: utf-8
require "mqtt"

MQTT::Client.connect(host: "a1f18lql3l5z0z.iot.ap-northeast-1.amazonaws.com",
                     port: 8883,
                     ssl: true,
                     cert_file: "cert.pem",
                     key_file: "private-key.pem",
                     ca_file: "rootCA.pem") do |client|

  client.subscribe("wc/status")
  begin
    topic,message = client.get #ここでブロックする
    p [topic, message, Time.now]
  end while true
end
