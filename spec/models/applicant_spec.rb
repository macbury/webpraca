require 'spec_helper'


describe Applicant do
  it "should create a new instance given valid attributes" do
    Factory.build(:applicant).save!
  end

  it "should generate unique token for new applicant" do
    applicant = Factory.build(:applicant, :token => nil)
    applicant.save!
    applicant.token.should_not == nil

    Factory.build(:applicant, :token => applicant.token).save!
    applicant.class.find_by_token(applicant.token).should_not be_kind_of Array
  end

  it "should send e-mail to job's publisher for new applicant" do
    applicant = Factory.build(:applicant)
    applicant.should_receive(:send_email)
    applicant.save!
  end
end

