require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

require 'some_random_class'

describe ObjectContext::CompositionError do
  subject do 
    described_class.new construction_args
  end

  let :construction_args do
    {
      :object_definition => object_definition, 
      :provided => []
    }
  end

  let :object_definition do
    ObjectContext::ObjectDefinition.new(
      :owner => SomeRandomClass,
      :component_names => []
    )
  end

  describe "when missing one required component" do
    before { object_definition.component_names << :an_object }
    
    it "indicates the missing object" do
      subject.message.should == "Wrong components when building new SomeRandomClass: Missing required object(s) [:an_object]."
    end
  end

  describe "when missing multiple required components" do
    before do
      object_definition.component_names << :an_object
      object_definition.component_names << :another_object
    end

    it "indicates all missing objects" do
      subject.message.should == "Wrong components when building new SomeRandomClass: Missing required object(s) [:an_object, :another_object]."
    end
  end

  describe "when an unexpected component is provided" do
    before { construction_args[:provided] = [ :surprise ] }

    it "calls out the unexpected object" do
      subject.message.should == "Wrong components when building new SomeRandomClass: Unexpected object(s) provided [:surprise]."
    end
  end

  describe "when multiple unexpected components are provided" do
    before { construction_args[:provided] = [ :surprise, :hello ] }
    it "calls out all unexpected objects" do
      subject.message.should == "Wrong components when building new SomeRandomClass: Unexpected object(s) provided [:surprise, :hello]."
    end
  end

  describe "when unexpected components are provided AND required components are missing" do
    before do
      object_definition.component_names << :part_one
      object_definition.component_names << :part_two
      object_definition.component_names << :part_three
      construction_args[:provided] = [ :part_two, :surprise_one, :surprise_two ]
    end

    it "generates a message for both missing AND unexpected components" do
      subject.message.should == "Wrong components when building new SomeRandomClass: Missing required object(s) [:part_one, :part_three]. Unexpected object(s) provided [:surprise_one, :surprise_two]."
    end
  end

end
