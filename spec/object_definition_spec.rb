require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe ObjectContext::ObjectDefinition do
  def new_def(*args)
    ObjectContext::ObjectDefinition.new(*args)
  end

  it "has a field for :component_names and :owner and can be built with them" do
    object_def = new_def :owner => "the owner", :component_names => [ :one, :two ]
    object_def.owner.should == "the owner"
    object_def.component_names.should == [:one, :two]
  end

  it "defaults :component_names to an empty array" do
    object_def = new_def :owner => "the owner"
    object_def.owner.should == "the owner"
    object_def.component_names.should be_empty
  end

  it "defaults :owner to nil" do
    object_def = new_def :component_names => [ :one, :two ]
    object_def.owner.should nil
    object_def.component_names.should == [:one, :two]
  end

  it "can be built with no args" do
    object_def = new_def
    object_def.owner.should nil
    object_def.component_names.should be_empty
  end
end
