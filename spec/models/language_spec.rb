require 'spec_helper'


describe Language do
  it "should obtain all languages with theirs jobs count" do
    job = Factory.build(:job)
    job.save!

    Language.find_job_languages.each do |language|
      language.jobs_count.should == "1" if language == job.language
    end
  end
end

