require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")


describe "simple object creation" do
  subject { new_object_context }

  before do
    append_test_load_path "simple_stuff"
    require 'some_random_class'
  end

  after do
    restore_load_path
  end

  it "constructs simple objects" do
    obj = subject.get('some_random_class')
    obj.should_not be_nil
    obj.class.should == SomeRandomClass
  end

  it "caches and returns references to same objects once built" do
    obj = subject.get('some_random_class')
    obj.should_not be_nil
    obj.class.should == SomeRandomClass

    obj2 = subject.get('some_random_class')
    obj2.should_not be_nil
    obj2.class.should == SomeRandomClass

    obj.object_id.should == obj2.object_id
  end

  it "can use strings and symbols interchangeably for object keys" do
    obj = subject.get('some_random_class')
    obj.should_not be_nil
    obj2 = subject.get(:some_random_class)
    obj.object_id.should == obj2.object_id
  end

end

