require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe ObjectContext do
  subject do
    ObjectContext.new(:parent_context => parent_context)
  end

  let :parent_context do mock(:parent_context) end

  describe "#get" do
    describe "when an object has been #put" do
      before { subject.put(:kraft, "verk") }

      it "returns the #put object" do
        subject.get(:kraft).should == "verk"
      end
    end

    describe "when the object is not in the cache" do
      describe "and the parent context has got the requested object" do
        before do
          parent_context.should_receive(:has?).with(:cheezburger).and_return(true)
          parent_context.should_receive(:get).with(:cheezburger).and_return("can haz")
        end

        it "returns the object from the parent context" do
          subject.get(:cheezburger).should == "can haz"
        end
      end

      describe "and the parent context does NOT have the requested object" do
        it "constructs the object anew using the object factory" 
        it "caches the results of using the object facatory"
      end

      describe "but there is no parent context" do
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
