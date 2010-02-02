require 'spec_helper'


describe Localization do
  it "should obtain all localizations with theirs jobs count" do
    job = Factory.build(:job)
    job.save!

    Localization.find_job_localizations.each do |localization|
      localization.jobs_count.should == "1" if localization == job.localization
    end
  end
end

