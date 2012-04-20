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
      attr_reader :name, :object_context

      def initialize(name,object_context)
        @name = name
        @object_context = object_context
      end

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
        :construct => lambda do |name,object_context|
          wood_constructs += 1
          wood_substitute.new name,object_context
        end
      }
    )

    fence = subject.get(:fence)
    fence.wood.should be
    fence.wood.to_s.should == "MDF"
    fence.wood.name.should == :wood
    fence.wood.object_context.should == subject
    wood_constructs.should == 1

    subject.get(:wood).should == fence.wood
    wood_constructs.should == 1
  end

end
