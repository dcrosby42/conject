
module Conject
  class ObjectFactory
    construct_with :class_finder, :dependency_resolver

    def construct_new(name, object_context)
      object = nil
      config = object_context.get_object_config(name)
      lambda_constructor = config[:construct]
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

      if !klass.object_peers.empty?
        anchor_object_peers object_context, klass.object_peers
      end

      constructor_func = nil
      if klass.has_object_definition?
        object_map = dependency_resolver.resolve_for_class(klass, object_context)
        constructor_func = lambda do klass.new(object_map) end

      elsif Utilities.has_zero_arg_constructor?(klass)
        # Default construction
        constructor_func = lambda do klass.new end
      else
        # Oops, out of ideas on how to build.
        raise ArgumentError.new("Class #{klass} has no special component needs, but neither does it have a zero-argument constructor.");
      end

      object = nil
      Conject.override_object_context_with object_context do
        object = constructor_func.call
      end
    end

    def anchor_object_peers(object_context, object_peers)
      object_peers.each do |name|
        object_context.configure_objects(name => {})
      end
    end
  end
end
