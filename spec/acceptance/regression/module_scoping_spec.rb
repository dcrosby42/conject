require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")


describe "module scoping" do
  subject { new_object_context }

  before do
    append_test_load_path "namespace"
    require 'chart/model'
    require 'chart/presenter'
    require 'chart/view'
  end

  after do
    restore_load_path
  end

  it "constructs objects with module-scoped classes" do
    obj = subject.get('chart/model')
    obj.should_not be_nil
    obj.class.should == Chart::Model
  end

  it "supports symbols as keys" do
    obj = subject.get(:'chart/model')
    obj.should_not be_nil
    obj.class.should == Chart::Model
  end

  it "lets objects depend on module-namespaced components" do
    obj = subject.get('chart/presenter')
    obj.should_not be_nil
    obj.class.should == Chart::Presenter

    model = obj.send(:model)
    model.should be
    model.class.should == Chart::Model

    view = obj.send(:view)
    view.should be
    view.class.should == Chart::View
  end

end

