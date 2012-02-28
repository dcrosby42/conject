require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "ObjectContext" do
  subject { Conject.default_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'master_of_puppets'
  end

  after do
    restore_load_path
  end

  it "caches a reference to itself using the name :this_object_context" do
    subject[:this_object_context].should == subject
  end

  it "can therefore provide :this_object_context as a reference to the constructing ObjectContext " do
    master = subject.get('master_of_puppets')
    master.this_object_context.should == subject

    master.this_object_context.get('master_of_puppets').should == master
  end


end

