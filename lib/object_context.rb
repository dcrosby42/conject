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

  def put(name, object)
    @cache[name] = object
  end

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

  def has?(name)
    i_have_it = @cache.keys.include?(name)
    return true if i_have_it

    # Ask parent (if i have a parent) if I don't have the object:
    if !parent_context.nil?
      return parent_context.has?(name)
    else
      # I don't have it.  My parent doesn't have it.
      return false
    end
  end
end


