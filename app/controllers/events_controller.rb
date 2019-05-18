class EventsController < ApplicationController
	before_action :get_event, only: [:show, :update, :edit, :destroy]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@events = Event.all
	end

	private

	def get_event
		#@event = Event.all
		@event = Event.find(params[:id])
	end

end
