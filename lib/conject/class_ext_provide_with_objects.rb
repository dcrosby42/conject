require 'conject/utilities'
class Class
  def provide_with_objects(*syms)
    klass = self

    # Define an internal reader method per dependency:
    syms.each do |object_name|
      mname = Conject::Utilities.generate_accessor_method_name(object_name)
      class_def_private mname do
        object_context[object_name]
      end
    end
  end
end
