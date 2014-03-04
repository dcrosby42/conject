require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Conject::ObjectFactory do

  subject do
    described_class.new component_map
  end

  let :component_map do
    { :class_finder => class_finder, :dependency_resolver => dependency_resolver }
  end

  let :my_object_name do :my_object_name end

  let :class_finder do double(:class_finder) end
  let :dependency_resolver do double(:dependency_resolver) end

  let :object_context do double(:object_context) end

  let :my_object_class do Class.new end
  let :my_object do double(:my_object) end
  let :my_objects_components do double(:my_objects_components) end

  describe "#construct_new" do
    describe "for Type 1 object construction" do
      let(:object_config) do {} end
      before do
        object_context.stub(:get_object_config).and_return(object_config)
        my_object_class.stub(:class_def_private) # the effect of this is tested in acceptance tests
        my_object_class.stub(:object_peers).and_return([]) # the effect of this is tested in acceptance tests

        Conject::Utilities.stub(:has_zero_arg_constructor?).and_return true
      end

      describe "when target class has an object definition (implying composition dependencies)" do
        before do
          my_object_class.should_receive(:has_object_definition?).and_return true
        end
        describe "and no specialization has been made" do
          before do class_finder.should_receive(:find_class).with(my_object_name).and_return my_object_class end
          it "finds the object definition, pulls its deps, and instantiates a new instance" do
            dependency_resolver.should_receive(:resolve_for_class).with(my_object_class, object_context, nil).and_return my_objects_components
            my_object_class.should_receive(:new).with(my_objects_components).and_return(my_object)

            subject.construct_new(my_object_name, object_context).should == my_object
          end
        end

        describe "when specialization is provided" do
          let(:overrides) do { remapped: "names" } end
          let(:object_config) do { :class => my_object_class, :specialize => overrides } end

          before do
            class_finder.should_not_receive(:find_class)#.with(my_object_name).and_return my_object_class
          end

          it "uses the specified class and remapped objects to reolve and build the object" do
            dependency_resolver.should_receive(:resolve_for_class).with(my_object_class, object_context, overrides).and_return my_objects_components
            my_object_class.should_receive(:new).with(my_objects_components).and_return(my_object)
            subject.construct_new(my_object_name, object_context).should == my_object
          end
        end

        describe "when :class is configured" do
          let(:object_config) do { :class => my_object_class } end

          before do
            class_finder.should_not_receive(:find_class)#.with(my_object_name).and_return my_object_class
          end

          it "uses the specified class to build the object" do
            dependency_resolver.should_receive(:resolve_for_class).with(my_object_class, object_context, nil).and_return my_objects_components
            my_object_class.should_receive(:new).with(my_objects_components).and_return(my_object)
            subject.construct_new(my_object_name, object_context).should == my_object
          end

        end
        
      end
        describe "when :class is not a Class" do
          let(:object_config) do { :class => "Oops! not a Class" } end
          it "raises" do
            lambda do subject.construct_new(my_object_name, object_context) end.should raise_error(/is not a Class/)
          end
        end

      describe "when target class has no object definition" do
        before do
          my_object_class.should_receive(:has_object_definition?).and_return false
          class_finder.should_receive(:find_class).with(my_object_name).and_return my_object_class
        end

        it "creates a new instance of the class without any arguments" do
          my_object_class.should_receive(:new).and_return(my_object)
          subject.construct_new(my_object_name, object_context).should == my_object
        end
      end

      describe "when target class has no object def, but also a non-default constructor" do
        before do
          my_object_class.should_receive(:has_object_definition?).and_return false
          Conject::Utilities.stub(:has_zero_arg_constructor?).and_return false
          class_finder.should_receive(:find_class).with(my_object_name).and_return my_object_class
        end

        it "raises a CompositionError" do
          lambda do
            subject.construct_new(my_object_name, object_context)
          end.should raise_error(ArgumentError)
        end

      end

      describe "when target constructor raises an error" do
        it "re-raises with an explanation" do
          class_finder.should_receive(:find_class).with(my_object_name).and_return my_object_class
          my_object_class.stub(:has_object_definition?).and_return false
          my_object_class.should_receive(:new).and_raise("BOOM")
          lambda do
            subject.construct_new(my_object_name, object_context)
          end.should raise_error(/Error while constructing object '#{my_object_name}'.*BOOM/)
        end
      end
    end



    describe "for custom lambda construction" do
      let(:object_config) do { :construct => lambda do "The Object" end } end
      let(:object_config2) do { :construct => lambda do |object_context| { :the_oc => object_context } end } end
      let(:object_config3) do { :construct => lambda do |name, object_context| { :the_name => name, :the_oc => object_context } end } end
      let(:object_config4) do { :construct => lambda do raise("the roof") end } end
      let(:object_config5) do { :construct => lambda do |a,b,c| "whatev" end } end

      before do
        object_context.stub(:get_object_config).with(:the_object).and_return(object_config)
        object_context.stub(:get_object_config).with(:the_other_object).and_return(object_config2)
        object_context.stub(:get_object_config).with(:the_third_object).and_return(object_config3)
        object_context.stub(:get_object_config).with(:the_fail_object).and_return(object_config4)
        object_context.stub(:get_object_config).with(:the_two_many_params).and_return(object_config5)
      end

      it "invokes the configured lambda in order to build the object" do
        subject.construct_new(:the_object, object_context).should == "The Object"
      end

      it "supplies object_context for lambdas with arity of 1" do
        obj = subject.construct_new(:the_other_object, object_context)
        obj.should be
        obj[:the_oc].should == object_context
      end

      it "supplies name, object_context for lambdas with arity of 2" do
        obj = subject.construct_new(:the_third_object, object_context)
        obj.should be
        obj[:the_name].should == :the_third_object
        obj[:the_oc].should == object_context
      end

      describe "when lambda has more than two args" do
        it "raises an error" do
          lambda do subject.construct_new(:the_fail_object, object_context) end.should raise_error(/the roof/)
        end
      end

      describe "when lambda raises an error" do
        it "raises an error" do
          lambda do subject.construct_new(:the_two_many_params, object_context) end.should raise_error(/constructor lambda takes 0, 1 or 2 params/i)
        end
      end
    end

    describe "'is' aliasing" do
      let(:object_config) do { :is => :specific_object  } end
      let(:specific_object) do "the specific object" end
      
      before do
        object_context.should_receive(:get_object_config).with(:generic_object).and_return(object_config)
        object_context.should_receive(:get).with(:specific_object).and_return(specific_object)
      end

      it "specifies that the configured object should be 'built' by pulling its target object from the object context" do
        subject.construct_new(:generic_object, object_context).should == specific_object
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
