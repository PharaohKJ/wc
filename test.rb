# coding: utf-8
class TweliteSerialData
  def initialize(v = nil)
    return if v.nil?
    @original = v
    @data = parse(v)
  end

  def parse(v)
    raise ArgumentError, 'データの長さが49文字ではありません' if v.size != 49
    parsed = {
      header:           v[0],
      from_device_id:   v[1..2],
      data_type:        v[3..4],
      packet_id:        v[5..6],
      protocol_version: v[7..8],
      quality:          v[9..10],
      hardware_id:      v[11..18],
      logical_id:       v[19..20],
      timestamp:        v[21..24],
      relay:            v[25..26],
      voltage:          v[27..30],
      not_use:          v[31..32],
      digital_in:       v[33..34],
      digital_change:   v[35..36],
      analog_in1:       v[37..38],
      analog_in2:       v[39..40],
      analog_in3:       v[41..42],
      analog_in4:       v[43..44],
      analog_corrector: v[45..46],
      checksum:         v[47..48]
    }
    {
      # key: v(bitmask)
      analog_in1: 0b00000011,
      analog_in2: 0b00001100,
      analog_in3: 0b00110000,
      analog_in4: 0b11000000
    }.each do |k, mask|
      if parsed[k] == 'FF'
        parsed[k] = -1
      elsif parsed[k] == '00'
        parsed[k] = 0
      else
        parsed[k] = (parsed[k].hex * 4 + (parsed[:analog_corrector].hex & mask)) * 4
      end
    end
    parsed
  end

  def [](key)
    @data[key]
  end
end

%w(
:7F8115016C810E2713003A27000C401C0000FF000000AB42
:7F81150169810E2713003A2A000C401C0000FF000000AB42
).each do |v|
  vs = TweliteSerialData.new(v)
  puts vs[:analog_in1]
end
