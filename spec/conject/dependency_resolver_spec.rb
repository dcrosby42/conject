require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Conject::DependencyResolver do

  subject { described_class.new(:class_finder => class_finder) }

  class StubbedObjectContext
    attr_accessor :objects
    def initialize(objects)
      @objects = objects
    end
    def get(name)
      @objects[name.to_sym] || @object[name.to_s]
    end
  end

  let :klass do
    Class.new do
      construct_with :cow, :dog
    end
  end

  let :oc_objects do { cow: "the cow", dog: "the dog", bessy: "the bessy", rover: "the rover" } end

  let :object_context do StubbedObjectContext.new(oc_objects) end

  let :class_finder do double("class finder") end

  before do
    class_finder.stub(:get_module_path)
  end

  it "maps the object definition component names of the given class to a set of objects gotten from the object context" do
    subject.resolve_for_class(klass, object_context).should == {
      cow: "the cow",
      dog: "the dog"
    }
  end

  it "uses optional remapping to look for different object names" do
    remapping = {dog: :rover}
    subject.resolve_for_class(klass, object_context, remapping).should == {
      cow: "the cow",
      dog: "the rover"
    }
  end

  it "optional remapping is string/symbol insensitive" do
    remapping = {dog: "rover", cow: :bessy}
    subject.resolve_for_class(klass, object_context, remapping).should == {
      cow: "the bessy",
      dog: "the rover"
    }
  end

  describe "when the class is in a module" do
    before do
      class_finder.stub(:get_module_path).with(klass).and_return("a/module/path")
      object_context.stub(:get).with("a/module/path/cow").and_return "the relative cow"
      object_context.stub(:get).with("a/module/path/dog").and_return "the relative dog"
    end

    it "first tries to lookup relative component names" do
      subject.resolve_for_class(klass, object_context).should == {
        cow: "the relative cow",
        dog: "the relative dog",
      }
    end
  end
end

