here = File.expand_path(File.dirname(__FILE__))
$: << here + "/../lib"

require 'conject'

load here + "/car.rb"

# puts Car.respond_to?(:conject_new)
# puts String.respond_to?(:conject_new)
# 
context = Conject.default_object_context
context.configure_objects car: { cache: false }
car = context[:car]
puts car

load here + "/car.rb"

car = context[:car]
puts car

