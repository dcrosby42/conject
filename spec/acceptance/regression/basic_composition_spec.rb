require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "basic object composition" do
  subject { Conject.default_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'fence'
    require 'wood'
    require 'nails'
  end

  after do
    restore_load_path
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

