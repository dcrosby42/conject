module Conject
  class ObjectContext

    construct_with :parent_context, :object_factory

    def initialize
      @cache = { :this_object_context => self }
      @object_configs = Hash.new do |h,k| h[k] = {} end
    end

    # Inject a named object into this context
    def put(name, object)
      raise "This ObjectContext already has an instance or configuration for '#{name.to_s}'" if directly_has?(name)
      Conject.install_object_context(object, self)
      object.instance_variable_set(:@_conject_contextual_name, name.to_s)
      @cache[name.to_sym] = object
    end

    alias_method :[]=, :put

    # Retrieve a named object from this context.
    #   If the object is already existant in this context, return it.
    #   If we have a parent context and it contains the requested object, get and return object from parent context. (Recursive upward search)
    #   If the object exists nowhere in this or a super context: construct, cache and return a new instance of the requested object using the object factory.
    def get(name)
      name = name.to_sym
      return @cache[name] if @cache.keys.include?(name)
      
      if !has_config?(name) and parent_context and parent_context.has?(name)
        return parent_context.get(name)
      else
        object = object_factory.construct_new(name,self)
        object.instance_variable_set(:@_conject_contextual_name, name.to_s)
        @cache[name] = object unless no_cache?(name)
        return object
      end
    end

    alias_method :[], :get

    def walk_up_contexts(&block)
      yield self
      parent_context.walk_up_contexts(&block) unless parent_context.nil?
    end

    def has?(name)
      walk_up_contexts do |context|
        return true if context.directly_has?(name)
      end
      return false
    end

    
    # Indicates if this context has the requested object in its own personal cache.
    # (Does not consult any parent contexts.)
    def directly_has?(name)
      @cache.keys.include?(name.to_sym) or has_config?(name.to_sym)
    end

    def has_config?(name)
      @object_configs.keys.include?(name.to_sym)
    end

    # Create and yield a new ObjectContext with this ObjectContext as its parent
    def in_subcontext
      yield Conject.create_object_context(self) if block_given?
    end


    #
    # Allow configuration options to be set for named objects.
    #
    def configure_objects(confs={})
      confs.each do |key,opts|
        key = key.to_sym
        @object_configs[key] ={} unless has_config?(key)
        @object_configs[key].merge!(opts)
      end
    end

    #
    # Get the object configuration options for the given name
    #
    def get_object_config(name)
      @object_configs[name.to_sym] || {}
    end

    def inspect
      "<ObjectContext 0x#{object_id.to_s(16)}>"
    end
    alias :to_s :inspect

    private 

    #
    # Returns true if an object has been specifically declared as non-cacheable.
    #
    def no_cache?(name)
      get_object_config(name)[:cache] == false
    end

  end
end
