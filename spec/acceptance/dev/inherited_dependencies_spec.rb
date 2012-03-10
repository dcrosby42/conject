require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "basic inheritance " do
  subject { new_object_context }

  before do
    append_test_load_path "basic_composition"
    require 'lobby'
    require 'front_desk'
    require 'guest'
    require 'special_guest'
    require 'very_special_guest'
    require 'tv'
  end

  context "simple subclasses of a class that uses construct_with" do
    it "gets built with its superclass's dependencies" do
      # grab the subtype object:
      special_guest = subject[:special_guest]
      special_guest.should be

      # grab some of the deps 
      tv = subject[:tv]
      front_desk = subject[:front_desk]

      # See the right deps got injected:
      special_guest.tv.should == tv
      special_guest.front_desk.should == front_desk

      # Double-check the original guest object
      guest = subject[:guest]
      guest.should be
      guest.tv.should == tv
      guest.front_desk.should == front_desk
    end
  end

  context "sub-subclasses of a class that uses construct_with" do
    it "gets built with its superclass's dependencies" do
      # grab the subtype object:
      very_special_guest = subject[:very_special_guest]
      very_special_guest.should be

      # grab some of the deps 
      tv = subject[:tv]
      front_desk = subject[:front_desk]

      # See the right deps got injected:
      very_special_guest.tv.should == tv
      very_special_guest.front_desk.should == front_desk
    end
  end

end
