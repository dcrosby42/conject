$: << "."
require 'metaid'

class Class

  def construct_with(*syms)
    #puts "Class #{name} wishes to be constructed with #{syms.inspect}"

    klass = self

    # TBD: generate dep info object and set it into the metaclass, based on the list
    # of given component names:
    # ObjectContext::Definition.build_dependency_info(:component_names => syms)
    # klass.meta_def :

    klass.class_def_private :components do 
      @_components ||= {}
    end

    klass.class_def_private :set_components do |component_map|
      components.merge! component_map
      puts "set_components called on #{self.class.name} with #{component_map.inspect}.  Remember I need #{syms.inspect}"
    end

    object_context_prep = {
      :initialize_has_been_wrapped => false
    }
    # klass.meta_def :object_context_prep do
    #   @_object_context_prep ||= {
    #     :initialize_has_been_wrapped => false
    #   }
    # end

    # Alias :new such that we can wrap and invoke it later
    klass.meta_eval do 
      alias_method :actual_new, :new
    end

    # Override default :new behavior for this class:
    klass.meta_def :new do |component_map|

      # We only want to do the following one time, but we've waited until now
      # in order to make sure our metaprogramming didn't get ahead of the user's
      # own definition of initialize:
      unless object_context_prep[:initialize_has_been_wrapped]
        puts "  (wrapping :initialize, should only happen once)"

        # Define a new wrapper'd version of initialize that accepts and uses a component map
        alias_method :actual_initialize, :initialize
        class_def :initialize do |component_map|
          # Apply the given components
          set_components component_map

          # Invoke the normal initialize method.
          # User-defined initialize method may accept 0 args, or it may accept a single arg
          # which will be the component map.
          arg_count = method(:actual_initialize).arity
          case arg_count
          when 0
            actual_initialize
          when 1
            actual_initialize component_map
          else
            # We're not equipped to handle this
            raise "User-defined initialize method defined with #{arg_count} paramters; must either be 0, or 1 to receive the component map."
          end
        end
        # Make a note that the initialize wrapper has been applied
        object_context_prep[:initialize_has_been_wrapped] = true
      end

      # Instantiate an instance
      actual_new component_map 
    end
  end

end

class Car
  construct_with :doors

  def initialize
    puts "User defined initialize: Construcing a new Car"#, doors=#{doors}"
    #puts "Constructing a new Car a=#{a} b=#{b}"#, doors=#{doors}"
  end

end

class Doors
  def initialize
    puts "Doors constructed the old fashioned way"
    $stdout.flush
  end
end

c = Car.new(:component => :map)
$stdout.flush
d = Doors.new
c2 = Car.new(:component => :map2)
p c
p d
p c2
#p c2.components # will fail, components should be private
puts "OK! (If this line prints out then the basic premise is working, though we're not really doing anything to assign components yet"
