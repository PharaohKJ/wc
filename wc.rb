class Wc
  def initialize
    @history = []
  end

  def add(r)
    @history << r
    return if @history.size < 2
    current = @history[-1]
    before = @history[-2]
    my_class = self.class
    callback_value =  0
    callback_value =  1 if my_class.in?(current)  && my_class.out?(before)
    callback_value = -1 if my_class.out?(current) && my_class.in?(before)
    yield(callback_value, current[:analog_in1])
    @history.slice!(0..-3)
  end

  def in?
    current = @history.last
    return false if current.nil?
    self.class.in?(current)
  end

  def out?
    current = @history.last
    return false if current.nil?
    !self.class.in?(current)
  end

  def self.in?(r)
    v = r[:analog_in1]
    v != -1 && v > min && v <= max
  end

  def self.out?(r)
    !in?(r)
  end

  def self.min
    (ENV.fetch('WC_MIN') { 400 }).to_i
  end

  def self.max
    (ENV.fetch('WC_MAX') { 600 }).to_i
  end
end
