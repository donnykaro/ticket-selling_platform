require 'rails_helper'


RSpec.describe Order, type: :model do
	user = FactoryGirl.create( :user )
	event = FactoryGirl.create( :event )
	normal_multiple_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "normal", selling_option: "multiple" )
	normal_altogether_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "normal", selling_option: "altogether" )
	normal_avloid_one_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "normal", selling_option: "avoid one" )
	concession_multiple_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "concession", selling_option: "multiple" )
	concession_altogether_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "concession", selling_option: "altogether" )
	concession_avoid_one_tickets = FactoryGirl.create( :ticket, event_id: event.id, ticket_type: "concession", selling_option: "avoid one" )

  it "can save order" do
    order_normal_multiple_tickets = Order.create!(user_id: user.id, ticket_id: normal_multiple_tickets.id, bill: 500, timestamp: Time.now, state: "reserved", multiple_tickets_amount: "15", altogether_tickets_amount: "", avoid_one_tickets_amount: "", ticket_type: "normal")
  	expect(order_normal_multiple_tickets).to be_valid
  end

  # it "should change user count from 0 to 1" do
  # end
end