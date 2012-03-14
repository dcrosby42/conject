require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "basic inheritance" do
  subject { new_object_context }

  before do
    append_test_load_path "inheritance"
    require 'vehicle'
    require 'wheel'
    require 'body'
    require 'car'
    require 'malibu'
    require 'emblem'
  end

  context "simple subclasses of a class that uses construct_with" do
    it "gets built with its superclass's dependencies" do
      # Check the base type object:
      vehicle = subject[:vehicle]
      vehicle.should be
      vehicle.hit_body.should == "body!"
      vehicle.hit_wheel.should == "wheel!"
      
      # grab the subtype object:
      car = subject[:car]
      car.should be
      car.hit_body.should == "body!"
      car.hit_wheel.should == "wheel!"
    end
  end

  context "class three levels deep in inheritance, adding a dep" do
    it "works" do
      malibu = subject[:malibu]
      malibu.hit_body.should == "body!"
      malibu.hit_wheel.should == "wheel!"
      malibu.hit_emblem.should == "chevy!"
    end
  end

  context "[initializers]" do
    context "superclass has user-defined #initialize with no args" do
      class Mammal
        construct_with :fur
        attr_reader :temp
        def initialize
          @temp = 98.6
        end
      end

      class Fur; end
      class Tree; end

      it "invokes super #initialize" do
        m = subject[:mammal]
        m.temp.should == 98.6
      end

      context "subclass has user-defined #initialize" do
        context "with 1 arg" do
          class Ape < Mammal
            construct_with :fur,:tree
            attr_accessor :got_map
            def initialize(map)
              @got_map = map
              super
            end
          end

          let(:chauncy) { subject[:ape] }

          it "invokes subclass custom #initialize with component map" do
            fur = subject[:fur]
            tree = subject[:tree]
            chauncy.got_map.should == { fur: fur, tree: tree }
          end

          it "invokes superclass #initialize" do
            chauncy.temp.should == 98.6
          end
        end

        context "with 0 args" do
          class Dog < Mammal
            construct_with :fur
            attr_accessor :legs
            def initialize
              @legs = 4
              super :whoa_there # superclass has a Conjected #initialize which requires the component map arg, though it's not used.  Ugh.
            end
          end
          
          let(:indy) { subject[:dog] }

          it "invokes subclass #initialize" do
            indy.legs.should == 4
          end

          it "invokes superclass #initialize" do
            indy.temp.should == 98.6
          end
        end
      end

      context "subclass has default #initialize" do
        class Cat < Mammal
          construct_with :fur
        end

        it "invokes superclass #initialize" do
          subject[:cat].temp.should == 98.6
        end
      end

      context "subclass has a no-arg #initialize that does NOT invoke #super" do
        class Shrew < Mammal
          construct_with :fur
          def initialize
          end
        end

        it "does not invoke superclass #initiailize" do
          subject[:shrew].temp.should be_nil
        end
      end

      context "subclass has a 1-arg #initialize that does NOT invoke #super" do
        class Shrew < Mammal
          construct_with :fur
          def initialize(map)
          end
        end

        it "does not invoke superclass #initiailize" do
          subject[:shrew].temp.should be_nil
        end
      end

    end
  end

end
