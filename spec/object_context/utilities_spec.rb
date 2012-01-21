require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'object_context/utilities'

describe ObjectContext::Utilities do
subject do described_class end

  before do
    @class_a = Class.new do end
    @class_b = Class.new do 
      def initialize
      end
    end
    @class_c = Class.new do 
      def initialize(x)
      end
    end
  end

  describe ".has_zero_arg_constructor?" do
    it "returns true when a class defines no initialize method" do
      subject.has_zero_arg_constructor?(@class_a).should be_true
    end
    it "returns true when a class defines initialize method without args" do
      subject.has_zero_arg_constructor?(@class_b).should be_true
    end
    it "returns false when a class defines initialize method WITH args" do
      subject.has_zero_arg_constructor?(@class_c).should be_false
    end
  end

end
