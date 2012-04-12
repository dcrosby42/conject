module Conject
  class ObjectContext

    construct_with :parent_context, :object_factory

    def initialize
      @cache = { :this_object_context => self }
    end

    # Inject a named object into this context
    def put(name, object)
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
      
      if parent_context and parent_context.has?(name)
        return parent_context.get(name)
      else
        object = object_factory.construct_new(name,self)
        @cache[name] = object
        return object
      end
    end

    alias_method :[], :get

    # Indicates if this context, or any parent context, contains the requested object in its cache.
    def has?(name)
      return true if directly_has?(name)

      # Ask parent (if i have a parent) if I don't have the object:
      if !parent_context.nil?
        return parent_context.has?(name)
      else
        # I don't have it, and neither do my ancestors.
        return false
      end
    end
    
    # Indicates if this context has the requested object in its own personal cache.
    # (Does not consult any parent contexts.)
    def directly_has?(name)
      @cache.keys.include?(name.to_sym)
    end

    def in_subcontext
      yield Conject.create_object_context(self) if block_given?
    end

  end
end
