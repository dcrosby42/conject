$: << "./lib"
require 'active_support/inflector'

class Dog
end

class Kennel
end

class ObjectBuilder
  def initialize
    @object_producers = {}
  end

  def construct_object(object_name, object_context)
    with_object_producer(object_name) do |producer|
      producer.produce 
    end
  end

  def is_singleton?(object_name)
    false
  end

  def set_object_producer(object_name, object_producer)
    @object_producers[object_name.to_sym] = object_producer
  end

  def set_singleton(object_name, object)
    set_object_producer object_name, SingletonProducer.new(object)
  end

  def set_simple_class(object_name, klass)
    set_object_producer(object_name, SimpleBuilder.new(klass))
  end


  def with_object_producer(object_name)
    object_name = object_name.to_sym
    producer = @object_producers[object_name]
    if !producer
      producer = find_or_generate_producer(object_name)
      if producer
        @object_producers[object_name] = producer
      end
    end

    if producer
      yield producer
    else
      raise "Cannot produce object '#{object_name.to_s}'"
    end
  end

  def find_or_generate_producer(object_name)
    c = Object.const_get(Conject::Utilities.camelize(object_name.to_s))
    if c
      return SimpleBuilder.new(c)
    end
  end
end

class ObjectProducer
  def produce
    raise "Can't produce objects with an abstract ObjectProducer"
  end
end

class SingletonProducer < ObjectProducer
  def initialize(object)
    @object = object
  end

  def produce
    @object
  end
end

class SimpleBuilder < ObjectProducer
  def initialize(klass)
    @class = klass
  end

  def produce
    @class.new
  end
end

class ObjectContext
  def initialize
    @object_builder = ObjectBuilder.new
    @objects = {}
  end

  def get_object(object_name)
    object_name = object_name.to_sym
    if @objects.keys.include?(object_name)
      return @objects[object_name]
    else
      object = @object_builder.construct_object(object_name, self)
      if @object_builder.is_singleton?(object_name)
        @objects[object_name] = object
      end
      return object
    end
  end

  def set_object(object_name, object)
    @objects[object_name.to_sym] = object
  end
end


context = ObjectContext.new

# context.set_simple_class(:dog, Dog)

p context.get_object(:dog)
p context.get_object(:dog)

context.set_object(:kennel, Kennel.new)

p context.get_object(:kennel)
p context.get_object(:kennel)

