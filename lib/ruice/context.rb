
module Ruice
  class Context
    def self.build
    end

    def initialize(name)
      @singletons = {}
      @blueprints = {}
    end

    def get(key)
      key = key.to_sym
      blueprint = get_blueprint(key)
      if blueprint.singleton?
        cached_object = @cache[key]
        if !cached_object
          construct_new_object blueprint
        end
      end
    end

    def get_blueprint(key)
      @blueprints[key] ||= generate_blueprint(key)
    end

    def generate_blueprint(key)
      Blueprint.new(
        :name => key,
        :context_singleton => false,
        :components => []
      )
    end

    def construct_new_object(blueprint)
      cname = Inflector.camelize(blueprint.name)
      clazz = get_class_for_name(cname)
      clazz.new
    end

    def get_class_for_name(class_name)
      class_name.split(/::/).inject(Object) do |mod,const_name| mod.const_get(const_name) end
    end
  end
end
