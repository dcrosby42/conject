$: << "../lib"
require 'object_context'
require 'object_context/utilities'

class A
end

class B
  def initialize
  end
end

class C
  def initialize(*x)
  end
end

class D
  def initialize(x)
  end
end


#
# RUBY 1.9.2 says Object#initialize is arity -1
# RUBY 1.9.3 (and 1.8.7??) say it's 0 (as expected)
# This discrepancy is being handled by ObjectContext::Utilities.has_zero_arg_constructor?
#
puts "RUBY_PLATFORM: #{RUBY_PLATFORM}"
puts "RUBY_VERSION: #{RUBY_VERSION}"
[A,B,C,D].each do |c|
  puts "Class #{c}#initialize arity: #{c.instance_method(:initialize).arity}"
  puts "Class #{c} has_zero_arg_constructor?: #{ObjectContext::Utilities.has_zero_arg_constructor?(c)}"
end
