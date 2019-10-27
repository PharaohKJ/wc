# coding: utf-8
class TweliteSerialData
  attr_reader :original
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
      analog_in1: [0b00000011, 8 * 0],
      analog_in2: [0b00001100, 8 * 2],
      analog_in3: [0b00110000, 8 * 4],
      analog_in4: [0b11000000, 8 * 6]
    }.each do |k, (mask, offset)|
      if parsed[k] == 'FF'
        parsed[k] = -1
      elsif parsed[k] == '00'
        parsed[k] = 0
      else
        offset_value = (parsed[:analog_corrector].hex & mask) >> offset
        parsed[k] = (parsed[k].hex * 4 + offset_value) * 4
      end
    end
    parsed
  end

  def [](key)
    @data[key]
  end
end
