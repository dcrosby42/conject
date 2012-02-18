require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Conject::DependencyResolver do

  class StubbedObjectContext
    attr_accessor :objects
    def initialize(objects)
      @objects = objects
    end
    def get(name)
      @objects[name]
    end
  end

  let :klass do
    Class.new do
      construct_with :cow, :dog
    end
  end

  let :oc_objects do { cow: "the cow", dog: "the dog" } end

  let :object_context do StubbedObjectContext.new(oc_objects) end

  it "maps the object definition component names of the given class to a set of objects gotten from the object context" do
    subject.resolve_for_class(klass, object_context).should == {
      cow: "the cow",
      dog: "the dog"
    }
  end
end

