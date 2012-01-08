class ObjectContext; end

# The rest of the libraries namespace themselves under ObjectContext so
# they must be required AFTER the initial definition of ObjectContext class.
require 'object_context/object_definition'
require 'object_context/class_ext_construct_with'

class ObjectContext

  construct_with :parent_context, :object_factory

  def initialize
    @cache = {}
  end

  # Inject a named object into this context
  def put(name, object)
    @cache[name] = object
  end

  # Retrieve a named object from this context.
  #   If the object is already existant in this context, return it.
  #   If we have a parent context and it contains the requested object, get and return object from parent context. (Recursive upward search)
  #   If the object exists nowhere in this or a super context: construct, cache and return a new instance of the requested object using the object factory.
  def get(name)
    object = @cache[name]
    return @cache[name] if @cache.keys.include?(name)
    
    if parent_context and parent_context.has?(name)
      return parent_context.get(name)
    else
      object = object_factory.construct_new(name,self)
      @cache[name] = object
      return object
    end
  end

  # Indicates if this context, or any parent context, contains the requested object in its cache.
  def has?(name)
    return true if directly_has?(name)

    # Ask parent (if i have a parent) if I don't have the object:
    if !parent_context.nil?
      return parent_context.has?(name)
    else
      # I don't have it.  My parent doesn't have it.
      return false
    end
  end
  
  # Indicates if this context has the requested object in its own personal cache.
  # (Does not consult any parent contexts.)
  def directly_has?(name)
    @cache.keys.include?(name)
  end
end


