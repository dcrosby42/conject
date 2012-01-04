# Metaid == a few simple metaclass helper
# (See http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html.)
class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  def meta_eval &blk; metaclass.instance_eval &blk; end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end
end

class Module
  # Defines an instance method within a module
  def module_def name, &blk
    module_eval { define_method name, &blk }
  end
  def module_def_private name, &blk
    module_def name, &blk
    private name
  end
end

class Class
  alias class_def module_def
  alias class_def_private module_def_private
end
