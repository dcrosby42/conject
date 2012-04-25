
module Conject
  class ClassFinder
    def find_class(name)
      cname = name.to_s.camelize
      cname_components = cname.split("::")
      dig_for_class Object, cname_components
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
      if within.const_defined?(name)
        within.const_get(name)
      else
        raise "Could not find class or module named #{name} within #{within}"
      end
    end

  end
end
