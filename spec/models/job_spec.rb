require 'spec_helper'

describe Job do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.build(:job).save!
  end
  
	it "should create new localization from name" do
		job = Factory.build(:job, :localization_name => "PongPongo")
		job.save!
		job.localization.name.should == "PongPongo"
	end
	
	it "should create new framework from name" do
		job = Factory.build(:job, :framework_name => "Train on Rails")
		job.save!
		job.framework.name.should == "Train on Rails"
	end
	
	it "should have pay band" do
		Factory.build(:job).pay_band?.should == true
	end
	
	it "availability_time should be 14 days" do
		Factory.build(:job).availability_time.should == 14
	end

  describe "highlighted?" do
    it "should be highlighted if rank >= 4.75" do
      Factory.build(:job, :rank => 5).should be_highlighted
    end
    
    it "should not be highlighted if rank < 4.75" do
      Factory.build(:job, :rank => 4.74).should_not be_highlighted
    end
  end
end
