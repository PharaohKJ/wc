# coding: utf-8
require './twelite_serial_data'
require 'date'

values = []
File.open(ARGV[0], 'r:utf-8') do |f|
  f.each_line do |line|
    v = line.split(' : ')
    local = DateTime.now
    next if v[1].nil?
    begin
      values << {
        time:  DateTime.parse(v[0][4..29]).new_offset(local.offset),
        value: TweliteSerialData.new(v[1].strip)
      }
    rescue => e
      # エラー行は読み捨て
      # puts e
    end
  end
end

values.each do |r|
  puts "#{r[:time].strftime("%Y/%m/%d %H:%M:%S")}, #{r[:value][:analog_in1]}"
end
