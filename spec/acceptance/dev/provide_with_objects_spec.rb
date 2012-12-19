require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "lazy dependency resolution via provide_with_objects" do
  subject { new_object_context }

  before do
    append_test_load_path "lazy_resolution"
    require 'hobbit/baggins'
    require 'hobbit/shire'
    require 'hobbit/precious'
  end

  after do
    restore_load_path
  end

  describe "for 'regular' context objects (instances)" do
    it "provides objects" do
      baggins = subject["hobbit/baggins"]
      baggins.to_s.should == "From the Shire, found the One Ring"
    end
  end

  describe "mixed lazy and construct with"
  describe "provide SELF with objects"
  describe "objects injected into context after construction"
  describe "module-relative dep names"

end

