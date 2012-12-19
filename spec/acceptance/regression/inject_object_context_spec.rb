require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "object referencing its own context" do
  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'kill_em_all'
    require 'ride_the_lightning'
    require 'master_of_puppets'
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

    describe "classes using construct_with" do
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

      it "will get object_context assigned as a result of being set into a context" do
        obj = AndJusticeForAll.new(ride_the_lightning: 'doesnt matter')
        context_before = begin
                           obj.send(:object_context)
                         rescue
                           nil
                         end
        context_before.should be_nil

        c2 = new_object_context
        c2[:my_obj] = obj
        obj.send(:object_context).should == c2
      end
    end

    describe "classes NOT using construct_with" do
      let(:ride) { subject.get('ride_the_lightning') }

      it "automatically get a private accessor for object_context, even if not requested" do
        ride.send(:object_context).should == subject
      end

      it "can use object_context in initialize" do
        ride.init_time_object_context.should == subject
      end

      it "will get object_context assigned as a result of being set into a context" do
        obj = KillEmAll.new
        lambda do obj.send(:object_context) end.should raise_error

        c2 = new_object_context
        c2[:my_obj] = obj
        obj.send(:object_context).should == c2
      end
    end

  end

end

