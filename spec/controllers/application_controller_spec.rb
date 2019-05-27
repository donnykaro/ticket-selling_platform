require "rails_helper"

RSpec.describe "Application management", :type => :request do

	before(:each) do
    @user = FactoryGirl.create( :user )
  end

  it "tries to acces user edit template, while not logged in" do
		# sign_in @user
		get root_path

		get "/users/edit/"
		expect(response).to redirect_to('/users/sign_in')
	end

	it "tries to load non exiting page" do
		sign_in @user
		get root_path

		get "/non_existing_path/"
		expect(response).to render_template('errors/not_found')
	end

end