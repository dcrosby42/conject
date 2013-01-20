class Car
  construct_with :engine, :chassis
  def initialize
    # puts "(car being constructed with #{engine} and #{chassis})#{caller.join("\n")}"
    puts "(car being constructed with #{engine} and #{chassis})"
  end
  def to_s
    "Car has #{engine} and #{chassis}"
  end
end

class Engine
  def to_s; "Engine!"; end
end

class Chassis
  def to_s; "Chassis!"; end
end
