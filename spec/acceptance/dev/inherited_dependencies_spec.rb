require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "basic inheritance " do
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

  # context "sub-subclasses of a class that uses construct_with" do
  #   it "gets built with its superclass's dependencies" do
  #     # grab the subtype object:
  #     malibu = subject[:malibu]
  #     # malibu.should be

  #     # # grab some of the deps 
  #     # wheel = subject[:wheel]
  #     # body = subject[:body]

  #     # # See the right deps got injected:
  #     # malibu.wheel.should == wheel
  #     # malibu.body.should == body
  #   end
  # end

end
