require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")
require 'some_random_class'

require 'fence'
require 'wood'
require 'nails'

describe "basic object creation" do
  subject { ObjectContext.default }

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

  it "constructs objects by providing necessary object components" do
    fence = subject.get('fence')
    fence.should_not be_nil

    fence.wood.should_not be_nil
    fence.wood.object_id.should == subject.get('wood').object_id

    fence.nails.should_not be_nil
    fence.nails.object_id.should == subject.get('nails').object_id
  end

end

