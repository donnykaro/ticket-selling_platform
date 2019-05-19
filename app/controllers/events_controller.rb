class EventsController < ApplicationController
	before_action :get_event, only: [:show, :update, :edit, :destroy]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@events = Event.all
	end

	def show
	end

	private

	def get_event
		@event = Event.find(params[:id])
		@event_tickets = @event.tickets#.where(ticket_type: 'normal').select(:amount)
		#@concession_tickets = @event.tickets.where(ticket_type: 'concession').select(:amount)
	end

end
