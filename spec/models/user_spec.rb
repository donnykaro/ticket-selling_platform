require 'rails_helper'


RSpec.describe User, type: :model do
	user = FactoryGirl.create( :user )
  it "user has a valid factory" do
    expect(user).to be_valid
  end

  # it "should change user count from 0 to 1" do
  # end
end