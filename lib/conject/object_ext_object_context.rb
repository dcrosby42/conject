class Object
  def object_context
    @_conject_object_context || Thread.current[:_overriding_conject_object_context] || Conject.default_object_context
  end

  def contextual_name
    @_conject_contextual_name
  end
end
