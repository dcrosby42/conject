require 'object_context'
require 'object_context/utilities'

class ObjectContext::ObjectFactory
  construct_with :class_finder, :dependency_resolver

  def construct_new(name, object_context)

    #
    # This implementation is what I'm loosely calling "type 1" or "regular" object creation:
    #  - Assume we're looking for a class to create an instance with
    #  - it may or may not have a declared list of named objects it needs to be constructed with
    #

    klass = class_finder.find_class(name)

    if klass.has_object_definition?
      object_map = dependency_resolver.resolve_for_class(klass, object_context)
      return klass.new(object_map)

    elsif ObjectContext::Utilities.has_zero_arg_constructor?(klass)
      # Default construction
      return klass.new
    else
      # Oops, out of ideas on how to build.
      raise ArgumentError.new("Class #{klass} has no special component needs, but neither does it have a zero-argument constructor.");
    end

  end
end
