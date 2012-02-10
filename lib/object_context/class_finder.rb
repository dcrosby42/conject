require 'object_context/borrowed_active_support_inflector'

class ObjectContext::ClassFinder
  def find_class(name)
    cname = name.camelize
    if Object.const_defined?(cname)
      Object.const_get(cname)
    else
      raise "Could not find class for #{name}"
    end
  end
end
