$: << "./lib"
require 'object_context'

class Donkey
  construct_with :head, :legs

  def journey
    head.talk
    legs.walk
  end
end

class Head
  construct_with :eyes, :mouth

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
