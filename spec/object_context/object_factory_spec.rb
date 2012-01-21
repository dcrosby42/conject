require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'object_context/object_factory'
require 'object_context/utilities'
# require 'object_context/composition_error'

describe ObjectContext::ObjectFactory do

  subject do
    described_class.new component_map
  end

  let :component_map do
    { :class_finder => class_finder, :dependency_resolver => dependency_resolver }
  end

  let :my_object_name do :my_object_name end

  let :class_finder do mock(:class_finder) end
  let :dependency_resolver do mock(:dependency_resolver) end

  let :object_context do mock(:object_context) end

  let :my_object_class do mock(:my_object_class) end
  let :my_object do mock(:my_object) end
  let :my_objects_components do mock(:my_objects_components) end

  describe "#construct_new" do
    before do
      class_finder.should_receive(:find_class).with(my_object_name).and_return my_object_class
      ObjectContext::Utilities.stub(:has_zero_arg_constructor?).and_return true
    end

    describe "when target class has an object definition (implying composition dependencies)" do
      before do
        my_object_class.should_receive(:has_object_definition?).and_return true
      end

      it "finds the object definition, pulls its deps, and instantiates a new instance" do
        dependency_resolver.should_receive(:resolve_for_class).with(my_object_class, object_context).and_return my_objects_components
        my_object_class.should_receive(:new).with(my_objects_components).and_return(my_object)

        subject.construct_new(my_object_name, object_context).should == my_object
      end
    end

    describe "when target class has no object definition" do
      before do
        my_object_class.should_receive(:has_object_definition?).and_return false
      end

      it "creates a new instance of the class without any arguments" do
        my_object_class.should_receive(:new).and_return(my_object)
        subject.construct_new(my_object_name, object_context).should == my_object
      end
    end

    describe "when target class has no object def, but also a non-default constructor" do
      before do
        my_object_class.should_receive(:has_object_definition?).and_return false
        ObjectContext::Utilities.stub(:has_zero_arg_constructor?).and_return false
      end

      it "raises a CompositionError" do
        lambda do
          subject.construct_new(my_object_name, object_context)
        end.should raise_error(ArgumentError)
      end
    end
  end
end

__END__


Decide that we're going to class Type 1 object creation:  
  Type 1 = create a normal object instance by invoking its constructors with a map of its declared object dependencies

Find class for object name
  assume strong naming convention

Ask class for dependency list

Get dependencies from context
Instantiate and return object



- definition

find definition

build_from(definition, context)
