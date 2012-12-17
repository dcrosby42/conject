require "conject/version"

require 'conject/object_definition'
require 'conject/extended_metaid'
require 'conject/class_ext_construct_with'
require 'conject/class_ext_object_peers'
require 'conject/object_context'
require 'conject/object_factory'
require 'conject/class_finder'
require 'conject/dependency_resolver'
require 'conject/utilities'
require 'conject/composition_error'
require 'conject/borrowed_active_support_inflector'

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
    class_finder = ClassFinder.new
    @default_object_factory ||=  ObjectFactory.new(
      :class_finder => class_finder,
      :dependency_resolver => DependencyResolver.new(:class_finder => class_finder)
    )
  end

  def self.create_object_context(parent_context, object_factory=nil)
    object_factory ||= default_object_factory
    ObjectContext.new(
      :parent_context => parent_context,
      :object_factory => object_factory
    )
  end
end
