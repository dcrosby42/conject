module Conject
  class DependencyResolver
    #
    # Given a Class, generate a map of dependencies needed to construct a new
    # instance of that class. Dependencies are looked up (and/or instantiated, as
    # determined within the ObjectContext) via the provided ObjectContext.
    #
    # This method assumes the Class has_object_defintion?  (Client code should
    # determine that before invoking this method.)
    #
    def resolve_for_class(klass, object_context)
      klass.object_definition.component_names.inject({}) do |obj_map, name|
        obj_map[name] = object_context.get(name)
        obj_map
      end
    end
  end
end
