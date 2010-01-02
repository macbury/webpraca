require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactMailer do
  
  describe 'sending contact notification' do

    before :each do    
      @contact_handler = mock_model(ContactHandler, 
                                    :subject => 'Message subject', 
                                    :body => 'Message body', 
                                    :email => 'sender@email.com')

      @mailer = ContactMailer.deliver_contact_notification(@contact_handler)
    end

    it "should set mail headers" do
      @mailer.to.first.should match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
      @mailer.from.should == ['sender@email.com']
      @mailer.subject.should match(/Message subject/)
    end

    it "should show content in body" do
      @mailer.body.should match(/Message subject/)
      @mailer.body.should match(/Message body/)
      @mailer.body.should match(/sender@email.com/)      
    end
    
  end
  
end