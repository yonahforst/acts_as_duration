class String
  def hhmmss
    n = 3
    seconds = self.split(':', n).inject(0) do |result, element|
      n -= 1
      result + element.to_i * 60**n      
    end
    ActiveSupport::Duration.new(seconds, [[:seconds, seconds]])
  end
  alias :hhmm :hhmmss
end

ActiveSupport::Duration.class_eval do
  
  DIVISORS = {seconds: 1, minutes: 60, hours: 3600, days: 86400}
  
  def to_unit(unit)
    if unit.to_sym == :hhmmss
      to_hhmmss(self.value) 
    else
      (self.value.to_f / DIVISORS[unit.to_sym])
    end
  end
  
  def to_hhmmss(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)

    format("%02d:%02d:%02d", hours, minutes, seconds)
  end
    
end