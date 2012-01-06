require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Class extension construct_with" do

  describe ".construct_with" do
    subject do
      Class.new do
        construct_with :object1, :object2

        def initialize
          @saw = "initialize has access to #{object1} and #{object2}"
        end

        def explain
          "Made of #{object1} and #{object2}"
        end

        def to_s
          @saw
        end
      end
    end

    it "lets you construct instances with sets of named objects" do
      instance = subject.new :object1 => "first object", :object2 => "second object"
      instance.explain.should == "Made of first object and second object"
    end

    it "sets objects before initialize is invoked" do
      instance = subject.new :object1 => "one", :object2 => "two"
      instance.to_s.should == "initialize has access to one and two"
    end

    it "defines the object accessors as private" do
      instance = subject.new :object1 => "one", :object2 => "two"
      lambda do instance.object1 end.should raise_error(NoMethodError)
      lambda do instance.object2 end.should raise_error(NoMethodError)
    end

    describe "when user defines initialize with one argument" do
      subject do
        Class.new do
          construct_with :ant, :aardvark

          attr_reader :map_string, :also

          def initialize(map)
            @map_string = map.inspect
            @also = "Preset #{ant} and #{aardvark}"
          end
        end
      end

      let :map do { :ant => "red", :aardvark => "blue" } end

      it "passes along the object map" do
        subject.new(map).map_string.should == map.inspect
      end

      it "still pre-sets the object accessors" do
        subject.new(map).also.should == "Preset red and blue"
      end
    end

    describe "when user doesn't define an initialize" do
      subject do
        Class.new do
          construct_with :something
          def to_s
            "Something is #{something}"
          end
        end
      end

      it "works normally" do
        subject.new(:something => "normal").to_s.should == "Something is normal"
      end
    end

    describe "when no object map is supplied to constructor" do
      it "raises a composition error"
    end

    describe "when object map does not contain all required objects" do
      it "raises a composition error explaining missing objects" 
    end

    describe "when object map contains objects that are not accepted" do
      it "raises a composition error explaining rejected objects" 
    end

    describe "when object map has a mix of missing and unexpected objects" do
      it "raises a composition error explaining missing and rejected objects" 
    end

  end

  describe ".object_definition"

  describe ".has_object_definition?"

end
