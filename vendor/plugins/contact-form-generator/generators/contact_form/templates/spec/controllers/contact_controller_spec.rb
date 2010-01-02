require File.dirname(__FILE__) + '/../spec_helper'

describe ContactController, "#route_for" do
  
  it "should map { :controller => 'contact', :action => 'new' } to /contact/new" do
    route_for(:controller => "contact", :action => "new").should == "/contact/new"
  end
  
  it "should map { :controller => 'contact', :action => 'create' } to /contact" do
    route_for(:controller => "contact", :action => "create").should == "/contact"
  end  

end

describe ContactController, "#params_from" do
  
  it "should generate params { :controller => 'contact', action => 'new' } from GET /contact" do
    params_from(:get, "/contact").should == {:controller => "contact", :action => "new"}
  end
  
  it "should generate params { :controller => 'contact', action => 'create' } from POST /contact" do
    params_from(:post, "/contact").should == {:controller => "contact", :action => "create"}
  end  
 
end


describe ContactController, "handling GET /contact" do
  
  before do
    @contact_handler = mock_model(ContactHandler, 
                                  :subject => 'Message subject', 
                                  :body => 'Message body', 
                                  :email => 'sender@email.com')
    ContactHandler.stub!(:new).and_return(@contact_handler)
    request.env["HTTP_REFERER"] = '/'    
  end

  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
    
  it "should initialize new contact_handler" do
    ContactHandler.should_receive(:new).and_return(@contact_handler)
    do_get
  end
    
  it "should assign the new contact_handler for the view" do
    do_get
    assigns(:contact_handler).should eql(@contact_handler)
  end
  
end


describe ContactController, "handling POST /contact" do

  before do    
    @contact_handler = mock_model(ContactHandler, 
                                  :subject => 'Message subject', 
                                  :body => 'Message body', 
                                  :email => 'sender@email.com')    
    ContactHandler.stub!(:new).and_return(@contact_handler)
    request.env["HTTP_REFERER"] = '/'    
  end

  def post_with_successful_save
    @contact_handler.should_receive(:save).and_return(true)
    post :create, :contact_handler => {}
  end
    
  def post_with_failed_save      
    @contact_handler.should_receive(:save).and_return(false)
    post :create, :contact_handler => {}
  end
    
  it "should create a new contact_handler" do
    ContactHandler.should_receive(:new).and_return(@contact_handler)
    post_with_successful_save
  end
      
  it "should redirect back on successful save" do
    post_with_successful_save
    response.should redirect_to('/')
  end
  
  it "should display flash on successful save" do
    post_with_successful_save
    flash[:notice].should match(/Thanks for your message/)
  end
    
  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end  

end
