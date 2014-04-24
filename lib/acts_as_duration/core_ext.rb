ActiveSupport::Duration.class_eval do
  
  DIVISORS = {seconds: 1, minutes: 60, hours: 3600, days: 86400}
  
  def to_unit(unit)
    self.value.to_f / DIVISORS[unit.to_sym]
  end
  
  DIVISORS.keys.each do |unit|
    define_method("to_#{unit}") {to_unit(unit)}
  end
end