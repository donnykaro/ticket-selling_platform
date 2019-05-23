class OrdersController < ApplicationController
	# before_action :get_order, only: [:show, :update, :edit, :destroy]
	before_action :get_event, only: [:new, :create]
	before_action :get_tickets, only: [:new, :create]
	before_action :get_ticket_selling_options, only: [:new, :create]

	def index
		@orders = Order.where(:user_id => current_user.id).order("created_at DESC")
	end

	def new
		@order = Order.new
	end

	def create
		flash[:alert] = []
		flash[:notice] = []
		if order_params[:multiple_tickets_amount] != "" && order_params[:multiple_tickets_amount].to_i % 2 == 0
			@order_multiple_hash = order_params
			@order_multiple_hash[:altogether_tickets_amount] = ""
			@order_multiple_hash[:avoid_one_tickets_amount] = ""
			ticket = @event.tickets.where(:selling_option => "multiple", :ticket_type => order_params[:ticket_type]).first
			@order_multiple_hash[:ticket_id] = ticket.id
			@order_multiple_hash[:bill] = @order_multiple_hash[:multiple_tickets_amount].to_i * ticket.price
			# @order_multiple = Order.new(o_params)
		end

		if order_params[:multiple_tickets_amount] != "" && order_params[:multiple_tickets_amount].to_i % 2 != 0
			flash[:alert].push("Number of multiple tickets has to be even")
		end

		if order_params[:altogether_tickets_amount] != "" && @altogether_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount == order_params[:altogether_tickets_amount].to_i
			@order_altogether_hash = order_params
			@order_altogether_hash[:multiple_tickets_amount] = ""
			@order_altogether_hash[:avoid_one_tickets_amount] = ""
			ticket = @event.tickets.where(:selling_option => "altogether", :ticket_type => order_params[:ticket_type]).first
			@order_altogether_hash[:ticket_id] = ticket.id
			@order_altogether_hash[:bill] = @order_altogether_hash[:altogether_tickets_amount].to_i * ticket.price
			# @order_altogether = Order.new(o_params)
		end

		if order_params[:altogether_tickets_amount] != "" && @altogether_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount != order_params[:altogether_tickets_amount].to_i
			flash[:alert].push("You can only buy all at once tickets of type altogether")
		end

		avoid_one_tickets_amount = @avoid_one_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount
		if order_params[:avoid_one_tickets_amount] != "" && (order_params[:avoid_one_tickets_amount].to_i == avoid_one_tickets_amount || (avoid_one_tickets_amount - order_params[:avoid_one_tickets_amount].to_i >= 2))
			@order_avoid_one_hash = order_params
			@order_avoid_one_hash[:multiple_tickets_amount] = ""
			@order_avoid_one_hash[:altogether_tickets_amount] = ""
			ticket = @event.tickets.where(:selling_option => "avoid one", :ticket_type => order_params[:ticket_type]).first
			@order_avoid_one_hash[:ticket_id] = ticket.id
			@order_avoid_one_hash[:bill] = @order_avoid_one_hash[:avoid_one_tickets_amount].to_i * ticket.price
			# @order_avoid_one = Order.new(o_params)
		end

		if order_params[:avoid_one_tickets_amount] != "" && (order_params[:avoid_one_tickets_amount].to_i != avoid_one_tickets_amount || (avoid_one_tickets_amount - order_params[:avoid_one_tickets_amount].to_i <= 2))
			flash[:alert].push("Avoid one can only be bought so there will be other quantity left than one")
		end

		orders = [@order_multiple_hash, @order_altogether_hash, @order_avoid_one_hash]
		try_to_save = orders.map { |order| Order.new(order).save }
		render 'orders/index'
		# pry

		if @order_multiple_hash != nil && order_params[:multiple_tickets_amount] != "" &&  try_to_save[0] == false
			pry
			Order.new(@order_multiple_hash).save.errors.each do |error|
				flash[:alert].push(error)
			end
		end
		if @order_altogether != nil && order_params[:altogether_tickets_amount] != "" && try_to_save[1] == false
			Order.new(@order_altogether_hash).save.errors.each do |error|
				flash[:alert].push(error)
			end
		end
		if @order_avoid_one != nil && order_params[:avoid_one_tickets_amount] != "" && try_to_save[2] == false
			Order.new(@order_avoid_one_hash).save.errors.each do |error|
				flash[:alert].push(error)
			end
		end

		if try_to_save[0]
			flash[:notice].push("Multiple tickets order saved")
		end
		if try_to_save[1]
			flash[:notice].push("Altogether tickets order saved")
		end
		if try_to_save[2]
			flash[:notice].push("Avoid one tickets order saved")
		end
	end

	private
	
	# def get_order
	# 	@order = Order.find(params[:id])
	# end

	def get_event
		@event = Event.find(params[:event_id])
	end

	def get_tickets
		@tickets_type_and_price = Array.new
		@event.tickets.select(:ticket_type, :price).distinct.each do |tickets|
			# pry
			# tickets = @event.tickets.where(ticket_type: ticket_type.ticket_type).first
			@tickets_type_and_price.push([tickets.ticket_type, tickets.price])
		end
	end

	def get_ticket_selling_options
		@multiple_tickets = @event.tickets.where(:selling_option => "multiple")
		@altogether_tickets = @event.tickets.where(:selling_option => "altogether")
		@avoid_one_tickets = @event.tickets.where(:selling_option => "avoid one")
		# @tickets_type_selling_option_and_price = @event.tickets#.select(:ticket_type, :selling_option, :amount)#.each do |tickets|
		# 	@tickets_type_and_price.push([tickets.ticket_type, tickets.selling_option, tickets.amount])
		# end
	end

	def order_params
		params.require(:order).permit(:user_id, :ticket_id, :bill, :timestamp, :multiple_tickets_amount, :altogether_tickets_amount, :avoid_one_tickets_amount, :ticket_type)
	end
end
