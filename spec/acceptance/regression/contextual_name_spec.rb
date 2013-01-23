require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Object#contextual_name" do

  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'fence'
    require 'wood'
    require 'nails'

    append_test_load_path "namespace"
    require 'chart/model'
    require 'chart/presenter'
    require 'chart/view'
  end

  after do
    restore_load_path
    42.instance_variable_set(:@_conject_object_context, nil)
    42.instance_variable_set(:@_conject_contextual_name, nil)
  end

  it "reveals the name of an object as it appears in the context" do
    fence = subject["fence"]
    fence.contextual_name.should == "fence"
  end
  
  it "includes the full module scope of the object in its contextual name" do
    presenter = subject["chart/presenter"]
    presenter.contextual_name.should == "chart/presenter"
  end

  it "works correctly for objects that have been defined via aliases" do
    subject.configure_objects :wooden_thing => { :is => :fence }
    subject[:wooden_thing].contextual_name.should == "wooden_thing"
    subject[:fence].contextual_name.should == "wooden_thing"
  end

  it "works correctly for objects that have been defined via custom constructor lambdas" do
    subject.configure_objects :the_answer => { :construct => lambda do 42 end }
    subject[:the_answer].contextual_name.should == "the_answer"
  end

  it "works for non-cached objects" do
    subject.configure_objects :fence => { :cache => false }
    fence1 = subject[:fence]
    fence2 = subject[:fence]
    fence1.object_id.should_not == fence2.object_id
    fence1.contextual_name.should == "fence"
    fence2.contextual_name.should == "fence"
  end

  it "works even for objects that were injected into a context after being constructed" do
    subject[:the_answer] = 42
    42.contextual_name.should == "the_answer"
  end

  it "prefers the most recently used name, if re-added to a context multiple times with different names" do
    subject[:a_number] = 42
    42.contextual_name.should == "a_number"
    subject[:the_answer] = 42
    42.contextual_name.should == "the_answer"
  end

  it "returns nil for objects that have never been added to a context" do
    42.contextual_name.should be_nil
    Wood.contextual_name.should be_nil
    Wood.new.contextual_name.should be_nil
  end
end

