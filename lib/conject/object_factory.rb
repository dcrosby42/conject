
module Conject
  class ObjectFactory
    construct_with :class_finder, :dependency_resolver

    def construct_new(name, object_context)
      object = nil
      lambda_constructor = object_context.get_object_config(name)[:construct]
      if lambda_constructor
        case lambda_constructor.arity
        when 0
          object = lambda_constructor[]
        when 1
          object = lambda_constructor[object_context]
        when 2
          object = lambda_constructor[name, object_context]
        else
          raise "Constructor lambda takes 0, 1 or 2 params; this lambda takes #{lambda_constructor.arity}"
        end

        # Provide a private accessor to the assigned object context
        class << object
          private
          def object_context
            @_conject_object_context #|| Conject.default_object_context
          end
        end
      else
        object = type_1_constructor(name, object_context)
      end

      # Stuff an internal back reference to the object context into the new object:
      object.send(:instance_variable_set, :@_conject_object_context, object_context)

      return object
    end

    private

    #
    # This implementation is what I'm loosely calling "type 1" or "regular" object creation:
    #  - Assume we're looking for a class to create an instance with
    #  - it may or may not have a declared list of named objects it needs to be constructed with
    #
    def type_1_constructor(name, object_context)
      klass = class_finder.find_class(name)
      object = nil

      # Provide a private accessor to the assigned object context
      klass.class_def_private :object_context do
        @_conject_object_context || Thread.current[:current_object_context] #|| Conject.default_object_context
      end

      if klass.has_object_definition?
        object_map = dependency_resolver.resolve_for_class(klass, object_context)
        Thread.current[:current_object_context] = object_context
        begin 
          object = klass.new(object_map)
        ensure
          Thread.current[:current_object_context] = nil
        end

      elsif Utilities.has_zero_arg_constructor?(klass)
        # Default construction
        Thread.current[:current_object_context] = object_context
        begin
          object = klass.new
        ensure
          Thread.current[:current_object_context] = nil
        end
      else
        # Oops, out of ideas on how to build.
        raise ArgumentError.new("Class #{klass} has no special component needs, but neither does it have a zero-argument constructor.");
      end

      return object

    end
  end
end
