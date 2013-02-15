module Conject
  class DependencyResolver
    construct_with :class_finder
    #
    # Given a Class, generate a map of dependencies needed to construct a new
    # instance of that class. Dependencies are looked up (and/or instantiated, as
    # determined within the ObjectContext) via the provided ObjectContext.
    #
    # This method assumes the Class has_object_defintion?  (Client code should
    # determine that before invoking this method.)
    #
    def resolve_for_class(klass, object_context, remapping=nil)
      remapping ||= {}
      klass.object_definition.component_names.inject({}) do |obj_map, name|
        obj_map[name] = search_for(klass, object_context, remapping[name.to_sym] || remapping[name.to_s] || name)
        obj_map
      end
    end


    private

    def search_for(klass, object_context, name)
      object = nil
      # If the asking class has a module namespace, first try looking relative 
      # to that module:
      if module_path = class_finder.get_module_path(klass)
        qualified_name = "#{module_path}/#{name}"
        begin
          object = object_context.get(qualified_name)
        rescue 
          # This means there's no relative object, which might be ok.
          # Fallback is to look for the requested object in the global namespace.
        end
      end
      # Search for the object by the specified name
      object ||= object_context.get(name)
    end
  end
end
