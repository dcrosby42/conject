require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe ObjectContext do
  subject do
    ObjectContext.new(:parent_context => parent_context, :object_factory => object_factory)
  end

  let :parent_context do mock(:parent_context) end
  let :object_factory do mock(:object_factory) end

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
        before do
          parent_context.should_receive(:has?).with(:cheezburger).and_return(false)
          parent_context.should_not_receive(:get)
          @but_i_ated_it = Object.new
          object_factory.should_receive(:construct_new).with(:cheezburger, subject).and_return(@but_i_ated_it)
        end

        it "constructs the object anew using the object factory" do
          subject.get(:cheezburger).should == @but_i_ated_it
        end

        it "caches the results of using the object facatory" do
          subject.get(:cheezburger).should == @but_i_ated_it
          # mock object factory would explode if we asked it twice:
          subject.get(:cheezburger).should == @but_i_ated_it
        end

      end

      describe "but there is no parent context" do
        let :parent_context do nil end
        before do
          @but_i_ated_it = Object.new
          object_factory.should_receive(:construct_new).with(:cheezburger, subject).and_return(@but_i_ated_it)
        end

        it "constructs the object anew using the object factory" do
          subject.get(:cheezburger).should == @but_i_ated_it
        end

        it "caches the results of using the object facatory" do
          subject.get(:cheezburger).should == @but_i_ated_it
          # mock object factory would explode if we asked it twice:
          subject.get(:cheezburger).should == @but_i_ated_it
        end
      end
    end
  end

  describe "#has?" do
    describe "when the object exists in the cache" do
      describe "due to #put" do
        it "returns true" do
          subject.put(:a_clue, "Wodsworth")
          subject.has?(:a_clue).should be_true
          subject.has?(:a_clue).should be_true
        end
      end
      describe "due to caching a previous #get" do
        before do
          parent_context.stub(:has?).and_return(false)
          object_factory.stub(:construct_new).and_return("Mr Green")
        end
        it "returns true" do
          subject.get(:a_clue).should == "Mr Green"
          subject.has?(:a_clue).should be_true
          subject.has?(:a_clue).should be_true
        end
      end
    end

    describe "when the object does NOT exist in the cache" do
      describe "when there is no parent context" do
        let :parent_context do nil end
        it "returns false" do
          subject.has?(:a_clue).should == false
        end
      end

      describe "when there is a parent context" do
        it "delegates the question to the parent context" do
          parent_context.should_receive(:has?).with(:a_clue).and_return("the parent answer")
          subject.has?(:a_clue).should == "the parent answer"
        end
      end
    end
  end

  # TODO: demonstrate that strings are usable as object names but everything gets done 
  #       in terms of symbol names (necessary?)
end
