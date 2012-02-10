require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")
require 'some_random_class'

describe "basic object creation" do
  subject { ObjectContext.default }

  it "constructs simple objects" do
    obj = subject.get('some_random_class')
    obj.should_not be_nil
    obj.class.should == SomeRandomClass
  end
end
