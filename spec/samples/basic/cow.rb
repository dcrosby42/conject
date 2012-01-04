class Object
  def composed_of(*a)
    puts "Hi #{a.inspect} from #{self}"
    class << self
      self.send :define_method, :hoss do puts 'hoss!' end
    end
  end
end

class Cow

  composed_of :meat, :milk

  def initialize(name)
    puts "initializer for Cow #{name}"
  end

  def self.new(*a)
    inst = super
    puts "New wrapper got instance: #{inst.inspect}"
    inst
  end
end

a = Cow.new "dave"
p a

a.hoss
