require 'test_helper'

class ApplicantTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Applicant.new.valid?
  end
end
