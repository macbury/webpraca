require 'spec_helper'


describe Framework do
  it "should obtain all frameworks with theirs jobs count" do
    job = Factory.build(:job)
    job.save!

    Framework.find_job_frameworks.each do |framework|
      framework.jobs_count.should == "1" if framework == job.framework
    end
  end
end

