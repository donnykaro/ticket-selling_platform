FactoryGirl.define do
  factory :event do
    name         							{ Faker::Esport.event }
    date_time  								{ Faker::Time.forward(30) }
    description       				{ Faker::Lorem.paragraph(10) }
  end
end