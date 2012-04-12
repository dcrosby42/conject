#
# Classes-as-objects can be a convenient way to build
# systems of objects that need to collaborate, but which 
# have no other need for repeated instantiation, or implementation
# substitutions within the roles.  (Ie, objects are what they are, and the
# system objects are more or less free of mutable state.)
#
# Ruby's classes, when declared "normally", are named objects available globally.
# So class S3, while a Class that could be used to generate instances, is also
# and _object_, a singleton named S3, and any other object can refer to this
# singleton by name.  Implement your functionality as class methods and you're ready to go.
#
# Drawbacks: 
#
#   You have to be right about not needing subcontexts or impl. 
#   substitution; without this assumption, you're left with nothing.
#
#   Code NOT written this way might have difficulty using Classes-as-objects code
#   
#   Classes-as-objects code cannot utilize systems that aren't written in the same way
#
#  A classes-as-objects system, if during development is discovered to break these assumptions,
#  they must be re-written.
#
# Observations:
#  Classes-as-objects is a special case of contextual objects: all system objects are 
#  singletons, no implementation substitution is ever required, dependency injection
#  is not required, and no construction-time behavior needs to be implemented.
#  (No constructors.  This isn't 100% off the table; there's always in-body configuration, eg,
#  via metacoding.)  All objects are at the top-most (global, or root) context in the application,
#  and no subcontexts are ever needed.
#
#  We could provide tooling to imply context for classes, and give them more abstract 
#  access to their constituents, in a way that can be modified orthogonally to their 
#  code.  (Whereas you can't change what it means for S3 to refer to NameFormatter, you _could_
#  change the way name_formatter is provided to the S3 class).
#
#  NEEDS:
#    - Let a class singleton declare itself to participate in a Context (root context by default)
#    - withing class singleton, reference collaborator objects contextually
#    - ObjectContext configuration: assume all objects are serviced by class singletons
#    - ObjcetContext configuration: object-by-object config to indicate class singletons


class S3
  use_class_in_context 
  class_depends_on :name_formatter

  class << self
    
    def store_file(name, data)
      formatted_name = name_formatter.format(name)
    end
  end
end

context.configure :use_class_singletons => true

context.configure_object :s3 => { :use_class_singleton => true }
# same as: context[:s3] = S3 ??

