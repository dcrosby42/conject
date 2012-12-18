require 'conject/utilities'
class Class
  def provide_with_objects(*syms)
    klass = self

    # Give instances of this class the ability to ref their object context
    klass.class_def_private :object_context do
      @_conject_object_context || Thread.current[:current_object_context] || Conject.default_object_context
    end

    # Define an internal reader method per dependency:
    syms.each do |object_name|
      mname = Conject::Utilities.generate_accessor_method_name(object_name)
      class_def_private mname do
        object_context[object_name]
      end
    end
  end
end
