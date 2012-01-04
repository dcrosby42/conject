require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'object_context/borrowed_active_support_inflector'

describe "Borrowed ActiveSupport Inflector" do
  describe "#camelize" do
    # it "converts lowercase strings into camel case" do
    #   "one two three".camelize.should == "OneTwoThree"
    # end

    it "converts underscored strings to camel case" do
      "four_five_six".camelize.should == "FourFiveSix"
    end

    it "leaves camel case words along" do
      "HoppingSizzler".camelize.should == "HoppingSizzler"
    end
  end

  describe "#underscore" do
    # it "converts lowercase strings into underscored case" do
    #   "one two three".underscore.should == "one_two_three"
    # end

    it "converts camel-case words to underscored" do
      "HoppingSizzler".underscore.should == "hopping_sizzler"
    end

    it "leaves underscored strings alone" do
      "four_five_six".underscore.should == "four_five_six"
    end
  end
end
