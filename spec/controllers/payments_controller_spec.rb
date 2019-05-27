require "rails_helper"

RSpec.describe "Payment management", :type => :request do

	before(:each) do
    @user = FactoryGirl.create( :user )
    @event = FactoryGirl.create( :event )
    @multiple_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "multiple", amount: 100, price: 100 )
    # @altogether_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "altogether", amount: 100, price: 100 )
    # @avoid_one_tickets = FactoryGirl.create( :ticket, event_id: @event.id, ticket_type: "normal", selling_option: "avoid one", amount: 100, price: 100 )
    @reserved_order = Order.create(user_id: @user.id, ticket_id: @multiple_tickets.id, bill: 50, timestamp: Time.now, state: "reserved", multiple_tickets_amount: 50, altogether_tickets_amount: "", avoid_one_tickets_amount: "", ticket_type: @multiple_tickets.ticket_type )
    @expired_order = Order.create(user_id: @user.id, ticket_id: @multiple_tickets.id, bill: 50, timestamp: Time.now, state: "expired", multiple_tickets_amount: 50, altogether_tickets_amount: "", avoid_one_tickets_amount: "", ticket_type: @multiple_tickets.ticket_type )
  end

  it "creates correct payment for multiple tickets, checks user payments count, and redirects to user orders page" do
    
    sign_in @user
    get root_path
    get "/users/#{@user.id}/orders/#{@reserved_order.id}/payments/new"
    expect(response).to render_template(:new)

    post "/users/#{@user.id}/orders/#{@reserved_order.id}/payments/", :params => {:payment => {:user_id => @user.id, :order_id => @reserved_order.id, :hashed_card => "123456789", :bill => @reserved_order.bill, :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :expiration_date => Faker::Time.forward(1200), :security_code => 123}}
    expect(@user.payments.count).to eq(1)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:success]).to be_present
    expect(flash[:success]).to eq("Payment successful")
  end

  it "creates incorrect payment for multiple tickets, checks user payments count, and redirects to user orders page" do
    sign_in @user
    get root_path
    get "/users/#{@user.id}/orders/#{@expired_order.id}/payments/new"
    expect(response).to render_template(:new)

    post "/users/#{@user.id}/orders/#{@expired_order.id}/payments/", :params => {:payment => {:user_id => @user.id, :order_id => @expired_order.id, :hashed_card => "123456789", :bill => @expired_order.bill, :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :expiration_date => Faker::Time.forward(1200), :security_code => 123}}
    expect(@user.payments.count).to eq(0)

    expect(response).to redirect_to("/users/#{@user.id}/orders")
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to eq("The order has expired")
  end
end