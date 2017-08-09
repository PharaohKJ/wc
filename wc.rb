class Wc
  def initialize
    @history = []
  end

  def add(r)
    @history << r
    if @history.size >= 2
      current = @history[-1]
      before = @history[-2]
      my_class = self.class
      yield(true)  if my_class.in?(current)  && my_class.out?(before)
      yield(false) if my_class.out?(current) && my_class.in?(before)
    end
    @history.slice!(-2, 2)
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
    v > 300 && v <= 1500
  end

  def self.out?(r)
    !in?(r)
  end
end
