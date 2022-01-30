class Stats
  attr_accessor :n

  def initialize
    @n = @old_m = @new_m = @old_s = @new_s = 0
  end

  def clear
    @n = 0
  end

  def push(x)
    @n += 1
    if @n == 1
      @old_m = @new_m = x
      @old_s = 0.0
    else
      @new_m = @old_m + (x - @old_m).to_f / @n
      @new_s = @old_s + (x - @old_m) * (x - @new_m)
      @old_m = @new_m
      @old_s = @new_s
    end
    @old_m
  end
  alias_method :<<, :push

  def mean
    @n > 0 ? @new_m : 0
  end

  def variance
    @n > 1 ? @new_s.to_f / ( @n - 1 ) : 0
  end

  def stddev
    Math.sqrt(self.variance)
  end
end
