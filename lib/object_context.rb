class ObjectContext
  # construct_with :parent_context, :object_factory

  def initialize
    @cache = {}
    # @cache[:this_context] = self
  end

  def put(name, object)
    @cache[name] = object
  end

  def get(name)
    object = @cache[name]
    return object
    # object = @cache[name]
    # return object if !object.nil?
    # 
    # if parent_context and parent_context.contains(name)
    #   return parent_context.get(name)
    # else
    #   object = object_factory.construct_new(name, :in_context => self)
    #   @cache[name] = object
    #   return object
    # end
  end
end

# The rest of the libraries namespace themselves under ObjectContext so
# they must be required AFTER the initial definition of ObjectContext class.
require 'object_context/object_definition'
require 'object_context/class_ext_construct_with'

