require 'spec_helper'

describe Job do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.build(:job).save!
  end
  
  describe "highlighted?" do
    it "should be highlighted if rank >= 4.75" do
      Factory.build(:job, :rank => 5).should be_highlited
    end
    
    it "should not be highlighted if rank < 4.75" do
      Factory.build(:job, :rank => 4.74).should_not be_highlited
    end
  end
end
