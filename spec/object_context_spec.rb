require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe ObjectContext do
  describe "#get" do
    describe "when an object has been #put" do
      before { subject.put(:kraft, "verk") }

      it "returns the #put object" do
        subject.get(:kraft).should == "verk"
      end
    end

    describe "when the object is not in the cache" do
      describe "and the parent context has got the requested object" do
        it "returns the object from the parent context"
      end

      describe "and the parent context does NOT have the requested object" do
        it "constructs the object anew using the object factory"
        it "caches the results of using the object facatory"
      end
    end
  end

  describe "#has?" do
    describe "when the object exists in the cache" do
      it "returns true"
    end
    describe "when the object does NOT exist in the cache" do
      it "returns false"
      describe "when the parent context is set" do
        it "returns true"
      end
    end
  end

  # TODO: demonstrate that strings are usable as object names but everything gets done 
  #       in terms of symbol names (necessary?)
end
