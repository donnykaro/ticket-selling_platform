require "rails_helper"

RSpec.describe "Order management", :type => :request do

  before(:each) do
    @user = FactoryGirl.create( :user )
    @event = FactoryGirl.create( :event )
    @multiple_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "multiple", amount: 100, price: 100 )
    @altogether_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "altogether", amount: 100, price: 100 )
    @avoid_one_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "avoid one", amount: 100, price: 100 )
    # @concession_multiple_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "concession", selling_option: "multiple", amount: 100 )
    # @concession_altogether_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "concession", selling_option: "altogether", amount: 100 )
    # @concession_avoid_one_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "concession", selling_option: "avoid one", amount: 100 )
  end

  it "creates correct order for multiple tickets, checks user order count, billing, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @multiple_tickets.id, :bill => @multiple_tickets.price * 16, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "16", :altogether_tickets_amount => "", :avoid_one_tickets_amount => "", :ticket_type => @multiple_tickets.ticket_type}}
    expect(@user.orders.count).to eq(1)
    expect(@user.orders.last.bill).to eq(1600)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:success]).to be_present
    expect(flash[:success]).to include("Multiple tickets order saved")

  end

  it "creates incorrect order for multiple tickets, checks user order count, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @multiple_tickets.id, :bill => @multiple_tickets.price * 15, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "15", :altogether_tickets_amount => "", :avoid_one_tickets_amount => "", :ticket_type => @multiple_tickets.ticket_type}}
    expect(@user.orders.count).to eq(0)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to include("Number of multiple tickets has to be even, and cant be bigger than: #{@multiple_tickets.amount}")
  end


  it "creates correct order for altogether tickets, checks user order count, billing, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @altogether_tickets.id, :bill => @altogether_tickets.price * 100, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "", :altogether_tickets_amount => "100", :avoid_one_tickets_amount => "", :ticket_type => @altogether_tickets.ticket_type}}
    expect(@user.orders.count).to eq(1)
    expect(@user.orders.last.bill).to eq(10000)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:success]).to be_present
    expect(flash[:success]).to include("Altogether tickets order saved")
  end

  it "creates incorrect order for altogether tickets, checks user order count, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @altogether_tickets.id, :bill => @altogether_tickets.price * 15, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "", :altogether_tickets_amount => "15", :avoid_one_tickets_amount => "", :ticket_type => @altogether_tickets.ticket_type}}
    expect(@user.orders.count).to eq(0)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to include("You can only buy all at once tickets of type altogether, and cant be bigger than: #{@altogether_tickets.amount}")
  end


  it "creates correct order for avoid one tickets, checks user order count, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @avoid_one_tickets.id, :bill => @avoid_one_tickets.price * 100, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "", :altogether_tickets_amount => "", :avoid_one_tickets_amount => "100", :ticket_type => @avoid_one_tickets.ticket_type}}
    expect(@user.orders.count).to eq(1)
    expect(@user.orders.last.bill).to eq(10000)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:success]).to be_present
    expect(flash[:success]).to include("Avoid one tickets order saved")
  end

  it "creates incorrect order for avoid one tickets, checks user order count, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @avoid_one_tickets.id, :bill => @avoid_one_tickets.price * 16, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "", :altogether_tickets_amount => "", :avoid_one_tickets_amount => "99", :ticket_type => @avoid_one_tickets.ticket_type}}
    expect(@user.orders.count).to eq(0)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to include("Avoid one can only be bought so there will be other quantity left than one, and cant be bigger than: #{@avoid_one_tickets.amount}")
  end

  it "checks what happens with empty form" do
    
    sign_in @user
    get root_path
    get "/events/#{@event.id}/orders/new"
    expect(response).to render_template(:new)

    post "/events/#{@event.id}/orders", :params => {:order => {:user_id => @user.id, :ticket_id => @avoid_one_tickets.id, :bill => @avoid_one_tickets.price * 16, :timestamp => Time.now, :state => "reserved", :multiple_tickets_amount => "", :altogether_tickets_amount => "", :avoid_one_tickets_amount => "", :ticket_type => @avoid_one_tickets.ticket_type}}
    expect(@user.orders.count).to eq(0)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to include("Nothing saved, form empty")
  end
end