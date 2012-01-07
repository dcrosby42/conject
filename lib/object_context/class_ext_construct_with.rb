require 'object_context/extended_metaid'
require 'object_context/object_definition'
require 'object_context/composition_error'

class Class

  def construct_with(*syms)
    klass = self

    object_def = ObjectContext::ObjectDefinition.new(:owner => klass, :component_names => syms)
    klass.meta_def :object_definition do
      object_def
    end


    klass.class_def_private :components do 
      @_components ||= {}
    end

    syms.each do |object_name|
      class_def_private object_name do
        components[object_name]
      end
    end

    klass.class_def_private :set_components do |component_map|
      required = object_def.component_names
      provided = component_map.keys
      if required.to_set != provided.to_set
        raise ObjectContext::CompositionError.new(
          :object_definition => object_def,
          :required => required, 
          :provided => provided)
      end

      components.clear.merge! component_map

    end

    # Tidbits of state that our dynamically-defined functions herein
    # will close over.
    object_context_prep = {
      :initialize_has_been_wrapped => false,  # keep track of when a class's :initialize method has been wrapped
    }
    
    # Alias :new such that we can wrap and invoke it later
    klass.meta_eval do 
      alias_method :actual_new, :new
    end

    # Override default :new behavior for this class.
    #
    # The .new method is rewritten to accept a single argument:
    #   component_map: a Hash containing all required objects to construct a new instance.
    #                  Keys are expected to be symbols.
    # 
    # If user defines their own #initialize method, all components sent into .new
    # will be installed BEFORE the user-defined #initialize, and it may accept arguments thusly:
    # * zero args.  Nothing will be passed to #initialize
    # * single arg. The component_map will be passed.
    # * var args (eg, def initialize(*args)).  args[0] will be the component map.  NO OTHER ARGS WILL BE PASSED. See Footnote a)
    #
    klass.meta_def :new do |component_map|

      # We only want to do the following one time, but we've waited until now
      # in order to make sure our metaprogramming didn't get ahead of the user's
      # own definition of initialize:
      unless object_context_prep[:initialize_has_been_wrapped]
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
          when 1, -1  # See Footnote a) at the bottom of this file

            actual_initialize component_map

          else
            # We're not equipped to handle this
            raise "User-defined initialize method defined with #{arg_count} parameters; must either be 0, other wise 1 or -1 (varargs) to receive the component map."
          end
        end
        # Make a note that the initialize wrapper has been applied
        object_context_prep[:initialize_has_been_wrapped] = true
      end

      # Instantiate an instance
      actual_new component_map 
    end
  end

  def has_object_definition?
    respond_to?(:object_definition) and !object_definition.nil?
  end

end


# Footnote a) - Object#initialize arity funny business
#
# Before Ruby 1.9.3, Object#initialize has -1 arity by default and accepts 0 or
# more args.  1.9.3 changes Object#initialize to default to 0 args.  This is
# deliberate (and in my opinion a long-overdue correction) but a mild problem
# -- I have no idea how I would determine in 1.9.2 or earlier if a user has
# defined NO constructor at all.  However, passing component_map to an
# otherwise undefined initialize method won't hurt, so let's just do it.
#
# If in 1.9.3 a user really HAS defined a varargs #initialize, then let's
# expect that initialize method to conform to the same rules we're laying out
# for other cases: If you accept args at all, the first one will be the
# component_map.  In this case NO ADDITIONAL ARGS WILL BE PASSED.  (Who would send them in, anyway?)
# The idea here is that people using construct_with are not intending to construct
# new instances using some other input.
#
# Found this when struggling:
#   http://bugs.ruby-lang.org/issues/5542 - Bug #5542: Ruby 1.9.3-p0 changed arity on default initialization method
#
# crosby 2012-01-07
