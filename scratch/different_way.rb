$: << File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'conject/extended_metaid.rb'

# module CJ
#   class DepDef
#     attr_reader :object_name, :constructor_time
# 
#     def initialize(opts)
#       @object_name = opts[:object_name]
#       @constructor_time = opts[:constructor_time] || false
#     end
# 
#     def constructor_time?
#       @constructor_time
#     end
#   end
# end

class Class
  def construct_with(*object_names)
    klass = self
    @_conject_construct_with = object_names

    self.
    object_names.each do |n|
      self.class_def_private n do
        components[n]
      end
    end


    # @dep_defs = object_names.map do |x| CJ::DepDef.new(object_name: x, constructor_time: true) end

  end

  def constructor_dependencies
    @_conject_construct_with
  end

  # def self.new
  #   puts "?"
  # end
end

class Class
  def new(*a)
    puts "?"
    obj = allocate
    obj.initialize
    obj
  end
    # raise "No!"
end

class Car
  construct_with :engine, :chassis
  def initialize
    puts "Car#initialize"
  end

  def hi
    puts "hi"
  end
end

class Engine
end

class Chassis
end

c = Car.new
c.hi


# class Dog
#   def initialize
#     puts "Dog initialize"
#   end
# end
# 
