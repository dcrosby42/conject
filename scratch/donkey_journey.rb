$: << "."
require 'object_definition'

class Donkey
  depends_on :head, :legs

  def journey
    head.talk
    legs.walk
  end

end

class Head
  depends_on :eyes, :mouth

  def talk
    mouth.bray
    eyes.roll
  end
end

class Legs
  def walk
    puts "Clop clop!"
  end
end

class Eyes
  def roll
    puts "(eye roll)"
  end
end

class Mouth
  def bray
    puts "HAWWW!!"
  end
end

donkey = Donkey.new(
  :head => Head.new(
    :mouth => Mouth.new,
    :eyes => Eyes.new
  ),
  :legs => Legs.new
)

donkey.journey

