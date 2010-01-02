require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact/new.html.erb" do
  
  before(:each) do
    @contact_handler = mock_model(ContactHandler)
    @contact_handler.stub!(:subject).and_return('Message subject')
    @contact_handler.stub!(:body).and_return('Message body')
    @contact_handler.stub!(:email).and_return('Sender email')        
    
    assigns[:contact_handler] = @contact_handler
  end

  it "should render attributes on contact_handler" do
    render "/contact/new.html.erb"

    response.should have_tag("form[action=?][method=post]", contact_url) do
      with_tag("input#contact_handler_subject[name=?]", "contact_handler[subject]")
      with_tag("input#contact_handler_email[name=?]", "contact_handler[email]")      
      with_tag("textarea#contact_handler_body[name=?]", "contact_handler[body]")
    end
  end
end

