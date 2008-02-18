require File.expand_path(File.dirname(__FILE__)) + '/../../spec_helper'

describe Time, :construct do
  it "gives a time object" do
    Time.construct(2006, 1, 2, 0, 0, 0).should == Time.local(2006, 1, 2, 0, 0, 0)
    Time.construct(2006, 1, 2, 3, 0, 0).should == Time.local(2006, 1, 2, 3, 0, 0)
    Time.construct(2006, 1, 2, 3, 4, 0).should == Time.local(2006, 1, 2, 3, 4, 0)
    Time.construct(2006, 1, 2, 3, 4, 5).should == Time.local(2006, 1, 2, 3, 4, 5)
    # Time.construct(2008, 1, 1, 0, 0, 0).should be_a_kind_of(Time)
    # Time.construct(2008, 1, 1, 0, 0, 0).should == Time.local(2008, 1, 1, 0, 0, 0)
  end
  
  it "uses defaults" do
    Time.construct(2008).should == Time.local(2008, 1, 1, 0, 0, 0)
  end
  
  it "handles month overflow" do
    Time.construct(2005, 13).should == Time.local(2006, 1)
    # Time.construct(2008, 13, 1, 0, 0, 0).should == Time.local(2009, 1, 1, 0, 0, 0)
  end

  it "handles month overflow (month % 12 == 0)" do
    Time.construct(2000, 72).should == Time.local(2005, 12)
    # Time.construct(2008, 36, 1, 0, 0, 0).should == Time.local(2010, 12, 1, 0, 0, 0)
  end
  
  it "complains if day > 57" do
    lambda { Time.construct(2006, 1, 56) }.should_not raise_error
    lambda { Time.construct(2006, 1, 57) }.should raise_error
    # lambda { Time.construct(2008, 1, 56, 0, 0, 0) }.should_not raise_error
    # lambda { Time.construct(2008, 1, 57, 0, 0, 0) }.should raise_error
  end
  
  it "handles day overflow in leap years" do
    Time.construct(2004, 2, 33).should == Time.local(2004, 3, 4)
    # Time.construct(2008, 2, 30, 0, 0, 0).should == Time.local(2008, 3, 1, 0, 0, 0)
  end
  
  it "handles day overflow in non leap years" do
    Time.construct(2006, 1, 32).should == Time.local(2006, 2, 1)
    Time.construct(2006, 2, 33).should == Time.local(2006, 3, 5)
    Time.construct(2000, 2, 33).should == Time.local(2000, 3, 5)
    # Time.construct(2007, 2, 29, 0, 0, 0).should == Time.local(2007, 3, 1, 0, 0, 0)
  end
  
  it "handles hour overflow" do
    Time.construct(2006, 1, 1, 36).should == Time.local(2006, 1, 2, 12)
    Time.construct(2006, 1, 1, 144).should == Time.local(2006, 1, 7)
    # Time.construct(2008, 1, 1, 24, 0, 0).should == Time.local(2008, 1, 2, 0, 0, 0)
  end
  
  it "handles minute overflow" do
    Time.construct(2006, 1, 1, 0, 90).should == Time.local(2006, 1, 1, 1, 30)
    Time.construct(2006, 1, 1, 0, 300).should == Time.local(2006, 1, 1, 5)
    # Time.construct(2008, 1, 1, 0, 60, 0).should == Time.local(2008, 1, 1, 1, 0, 0)
  end
  
  it "handles second overflow" do
    Time.construct(2006, 1, 1, 0, 0, 90).should == Time.local(2006, 1, 1, 0, 1, 30)
    Time.construct(2006, 1, 1, 0, 0, 300).should == Time.local(2006, 1, 1, 0, 5, 0)
    # Time.construct(2008, 1, 1, 0, 0, 60).should == Time.local(2008, 1, 1, 0, 1, 0)
  end
end