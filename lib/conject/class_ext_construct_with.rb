require 'conject/utilities'
class Class

  def construct_with(*syms)
    klass = self

    #
    # Create the .object_definition accessor for this class.
    #
    # The ObjectDefinition stores information # on the dependencies required to
    # build new instances.
    # 
    object_def = Conject::ObjectDefinition.new(:owner => klass, :component_names => syms)
    klass.meta_def :object_definition do
      @object_definition
    end

    # TODO: actually, just use meta_eval here to set the ivar and move on.
    klass.meta_def :set_object_definition do |od| #XXX
      @object_definition = od
    end
    klass.set_object_definition(object_def) # XXX
    klass.meta_eval do private :set_object_definition end # XXX


    #
    # Define internal accessor methods for instances of klass
    #

    # The internal hash of dependencies, keyed by name:
    klass.class_def_private :components do 
      @_components ||= {}
    end
    # Have the components been set for this instance yet?
    klass.class_def_private :components_set? do 
      !@_components.nil?
    end

    # Define an internal reader method per dependency:
    syms.each do |object_name|
      Conject::Utilities.generate_accessor_method_names(object_name).each do |mname|
        class_def_private mname do
          components[object_name]
        end
      end
    end

    # Define the internal setter method that installs dependencies
    # in an instance of klass.
    # #set_components respects the rules set forth in the ObjectDefinition
    # for this class, and will raise a detailed exception if the rules
    # are violated.
    klass.class_def_private :set_components do |component_map|
      return if components_set? # do not repeat.  In inheritance town, a superclass must currently rely on all
                                # of its deps to be declared and set by subclass functionality.

      obj_def = self.class.object_definition
      required = obj_def.component_names
      provided = component_map.keys
      if required.to_set != provided.to_set
        # Explain the diff between what was required and what was actually provided:
        raise Conject::CompositionError.new(
          :object_definition => obj_def,
          :required => required, 
          :provided => provided)
      end

      # set all the components
      components.clear.merge! component_map
    end

    # .object_context_prep is used internally by klass to maintain some state regarding
    # its internal restructuring.
    klass.meta_def :object_context_prep do 
      @object_context_prep ||= {
        :initialize_has_been_wrapped => false
      }
    end
    klass.meta_eval do private :object_context_prep end
    
    klass.meta_def :new do |component_map|
      obj = allocate
      if has_object_definition?
        # Apply the given components
        obj.__send__(:set_components, component_map)
      else
        raise "#{self.class} has an ancestor that uses construct_with, but has not declared any component dependencies.  Will not be able to instantiate!"
      end

      arg_count = obj.method(:initialize).arity
      case arg_count
      when 0
        obj.__send__ :initialize

      when 1, -1  # See Footnote a) at the bottom of this file
        obj.__send__ :initialize, component_map

      else
        # We're not equipped to handle this
        raise "User-defined initialize method defined with #{arg_count} parameters; must either be 0, other wise 1 or -1 (varargs) to receive the component map."
      end

      obj
      
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
