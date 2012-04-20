require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "configuring objects to be built with a lambda" do
  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'fence'
    require 'wood'
    require 'nails'
  end

  let :wood_substitute do
    Class.new do
      def to_s
        "MDF"
      end
    end
  end

  after do
    restore_load_path
  end


  it "constructs and caches instances by running the given lamdba" do
    wood_constructs = 0

    subject.configure_objects(
      :wood => { 
        :construct => lambda do 
          wood_constructs += 1
          wood_substitute.new 
        end
      }
    )

    fence = subject.get(:fence)
    fence.wood.should be
    fence.wood.to_s.should == "MDF"
    wood_constructs.should == 1

    subject.get(:wood).should == fence.wood
    wood_constructs.should == 1
  end

end
