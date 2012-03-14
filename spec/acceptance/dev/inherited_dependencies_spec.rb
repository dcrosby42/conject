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
  end

  context "simple subclasses of a class that uses construct_with" do
    it "gets built with its superclass's dependencies" do
      # grab some of the deps 
      # wheel = subject[:wheel]
      # body = subject[:body]

      # Check the base type object:
      vehicle = subject[:vehicle]
      # vehicle.should be
      # vehicle.body.should == body
      # vehicle.wheel.should == wheel
      
      # grab the subtype object:
      car = subject[:car]
      # car.should be
      # car.wheel.should == wheel
      # car.body.should == body
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
