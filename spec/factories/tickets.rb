FactoryGirl.define do
  factory :ticket do
		# event = FactoryGirl.create( :event )
  #   event_id         					{ event.id }
    # ticket_type  							{ "normal" }
    # amount       							{ Faker::Number.within(20..200) }
    price											{	Faker::Number.within(20..100) }
    # selling_option						{ "multiple" }
  end
end