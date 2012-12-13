require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "object referencing its own context" do
  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'master_of_puppets'
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


end

