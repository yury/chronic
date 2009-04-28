require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper'

describe Chronic, "VERSION" do
  it "provides a version number" do
    Chronic::VERSION.should_not be_nil
  end
end

describe Chronic, :debug do
  it "is not in debug level by default" do
    Chronic.debug.should be_false
  end
end

