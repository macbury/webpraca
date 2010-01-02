require File.dirname(__FILE__) + '/../spec_helper'

describe ContactHandler do

  before(:each) do
    @valid_attributes = {
      :subject => "Message subject", 
      :body => "Message body",
      :email => "sender@email.com"
    }
  end

  describe "validations" do

    it "should create a valid contact_handler" do
      ContactHandler.new(@valid_attributes).should be_valid
    end

    it "should require subject" do
      contact_handler = ContactHandler.new(@valid_attributes.except(:subject))
      contact_handler.should_not be_valid
    end
    it "should require body" do
      contact_handler = ContactHandler.new(@valid_attributes.except(:body))
      contact_handler.should_not be_valid
    end    
    it "should require email" do
      contact_handler = ContactHandler.new(@valid_attributes.except(:email))
      contact_handler.should_not be_valid
    end
    it "should require a valid email address" do
      contact_handler = ContactHandler.new(@valid_attributes.merge(:email => 'cannot-has-valid@email'))
      contact_handler.should_not be_valid
    end    

  end

end
