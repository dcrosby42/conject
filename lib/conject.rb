
module Conject
  #
  # Provide access to the default ObjectContext.  
  # This context is created on first use, and can 
  # serve as the root of all other ObjectContexts.
  #
  def self.default_object_context
    @default_object_context ||= create_object_context(nil)
  end

  def self.default_object_factory
    @default_object_factory ||=  Conject::ObjectFactory.new(
      :class_finder => Conject::ClassFinder.new,
      :dependency_resolver => Conject::DependencyResolver.new
    )
  end

  def self.create_object_context(parent_context, object_factory=nil)
    object_factory ||= default_object_factory
    Conject::ObjectContext.new(
      :parent_context => parent_context,
      :object_factory => object_factory
    )
  end
end

# The rest of the libraries namespace themselves under Conject so
# they must be required AFTER the initial definition of Conject.
require 'conject/object_definition'
require 'conject/extended_metaid'
require 'conject/class_ext_construct_with'
require 'conject/object_context'
require 'conject/object_factory'
require 'conject/class_finder'
require 'conject/dependency_resolver'
require 'conject/utilities'
require 'conject/composition_error'
require 'conject/borrowed_active_support_inflector'
