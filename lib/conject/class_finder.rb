
class Conject::ClassFinder
  def find_class(name)
    cname = name.to_s.camelize
    if Object.const_defined?(cname)
      Object.const_get(cname)
    else
      raise "Could not find class for #{name}"
    end
  end
end
