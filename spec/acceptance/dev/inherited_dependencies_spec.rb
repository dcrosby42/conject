require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "basic inheritance " do
  subject { Conject.create_object_context(nil) }

  before do
    append_test_load_path "basic_composition"
    require 'lobby'
    require 'front_desk'
    require 'guest'
    require 'special_guest'
    require 'tv'
  end

  it 'is built with parental dependencies' do
    tv = subject[:tv]
    front_desk = subject[:front_desk]
    original_guest = subject[:guest]

    guest = subject[:special_guest]
    guest.should be
    guest.tv.should == tv
    guest.front_desk.should == front_desk
  end
end
