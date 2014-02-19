
module Conject
  class ClassFinder
    def find_class(name)
      cname = Utilities.camelize(name.to_s)
      cname_components = cname.split("::")
      dig_for_class Object, cname_components
    end

    def get_module_path(klass)
      cname = klass.name
      return nil unless cname =~ /::/
      cname_components = cname.split("::")
      cname_components.pop
      Utilities.underscore(cname_components.join("::"))
    end

    private

    def dig_for_class(within, steps)
      a = steps.shift
      const = get_constant(within, a)
      if steps.nil? or steps.empty?
        const
      else
        dig_for_class(const, steps)
      end
    end

    def get_constant(within, name)
      if within.const_defined?(name, false)
        within.const_get(name, false)
      else
        raise "Could not find class or module named #{name} within #{within}"
      end
    end

  end
end
