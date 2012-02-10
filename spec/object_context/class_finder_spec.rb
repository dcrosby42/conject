require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'object_context/class_finder'
require 'some_random_class'

describe ObjectContext::ClassFinder do

  subject do
    described_class.new
  end

  # let :component_map do
  #   { :class_finder => class_finder, :dependency_resolver => dependency_resolver }
  # end

  it "returns the class implied by the given name" do
    c = subject.find_class('some_random_class')
    c.should_not be_nil
    c.should == SomeRandomClass
  end

  it "raises an error if the name doesn't imply a regular class in the current runtime" do
    lambda do
      subject.find_class('something_undefined')
    end.should raise_error(/could not find class.*something_undefined/i)
  end

  it "raises an error for nil input" do
    lambda do
      subject.find_class('something_undefined')
    end.should raise_error(/could not find class.*something_undefined/i)
  end
end
