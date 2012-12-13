require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "object referencing its own context" do
  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'master_of_puppets'
    require 'ride_the_lightning'
    require 'and_justice_for_all'
  end

  after do
    restore_load_path
  end

  it "ObjectContext caches a reference to itself using the name :this_object_context" do
    subject[:this_object_context].should == subject
  end

  it "an object can inject :this_object_context as a reference to its constructing ObjectContext" do
    master = subject.get('master_of_puppets')
    master.this_object_context.should == subject

    master.this_object_context.get('master_of_puppets').should == master
  end

  describe "NEW AND IMPROVED" do

    describe "classes with object definitions" do
      let(:justice) { subject.get('and_justice_for_all') }
      let(:ride) { subject.get('ride_the_lightning') }

      it "automatically get a private accessor for object_context, even if not requested" do
        justice.send(:object_context).should == subject
        ride.send(:object_context).should == subject # watching out for interaction bugs wrt dependency construction
      end

      it "can use object_context in initialize" do
        justice.init_time_object_context.should == subject
        ride.init_time_object_context.should == subject # watching out for interaction bugs wrt dependency construction
      end
    end

    describe "classes WITHOUT object definitions" do
      let(:ride) { subject.get('ride_the_lightning') }

      it "automatically get a private accessor for object_context, even if not requested" do
        ride.send(:object_context).should == subject
      end

      it "can use object_context in initialize" do
        ride.init_time_object_context.should == subject
      end
    end

  end

end

