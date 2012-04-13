require 'metaid'
require 'set'

class ObjectDefinition
  attr_reader :component_names, :owner, :construction_type, :singleton

  def initialize(opts={})
    @owner = opts[:owner]
    @component_names = opts[:component_names] || []
    @construction_type = :instance
    @singleton = true
  end
end

class CompositionError < RuntimeError
  def initialize(opts={})
    object_def = opts[:object_definition]
    required = opts[:required]
    provided = opts[:provided]

    msg = "Wrong components when building new #{object_def.owner}: "

    missing = required - provided
    msg << "Missing required object(s) #{missing.to_a.inspect}. " unless missing.empty?

    unexpected = provided - required
    msg << "Encountered unexpected object(s) #{unexpected.to_a.inspect}. " unless unexpected.empty?

    super msg
  end
end

class Class

  def depends_on(*syms)
    klass = self

    object_def = ObjectDefinition.new(:owner => klass, :component_names => syms)
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
      required = object_def.component_names.to_set
      provided = component_map.keys.to_set
      if required != provided
        raise CompositionError.new(
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

  def has_object_definition?
    respond_to?(:object_definition) and !object_definition.nil?
  end

end

