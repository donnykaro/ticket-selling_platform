class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

	def handle_record_not_found
		render 'errors/not_found'
	end
end
