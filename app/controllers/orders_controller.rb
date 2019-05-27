class OrdersController < ApplicationController
	# before_action :get_order, only: [:show, :update, :edit, :destroy]
	# before_action :check_if_amount_is_zero, only: [:new, :create]
	before_action :get_event, only: [:new, :create]
	before_action :get_tickets, only: [:new, :create]
	before_action :get_ticket_selling_options, only: [:new, :create]
	before_action :check_if_expired

	def index
	end

	def new
		@order = Order.new
	end

	def create
		flash[:alert] = []
		flash[:success] = []
		if order_params[:multiple_tickets_amount] != "" && order_params[:multiple_tickets_amount].to_i % 2 == 0
			@order_multiple_hash = order_params
			@order_multiple_hash[:altogether_tickets_amount] = ""
			@order_multiple_hash[:avoid_one_tickets_amount] = ""
			ticket = @event.tickets.where(:selling_option => "multiple", :ticket_type => order_params[:ticket_type]).first
			@order_multiple_hash[:ticket_id] = ticket.id
			@order_multiple_hash[:bill] = @order_multiple_hash[:multiple_tickets_amount].to_i * ticket.price
			# @order_multiple = Order.new(o_params)
		end

		check_multiple_tickets_order

		if order_params[:altogether_tickets_amount] != "" && @altogether_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount == order_params[:altogether_tickets_amount].to_i
			@order_altogether_hash = order_params
			@order_altogether_hash[:multiple_tickets_amount] = ""
			@order_altogether_hash[:avoid_one_tickets_amount] = ""
			ticket = @event.tickets.where(:selling_option => "altogether", :ticket_type => order_params[:ticket_type]).first
			@order_altogether_hash[:ticket_id] = ticket.id
			@order_altogether_hash[:bill] = @order_altogether_hash[:altogether_tickets_amount].to_i * ticket.price
			# @order_altogether = Order.new(o_params)
		end

		check_altogether_tickets_order

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

		check_avoid_one_tickets_order avoid_one_tickets_amount

		orders = [@order_multiple_hash, @order_altogether_hash, @order_avoid_one_hash]
		try_to_save = orders.map { |order| Order.new(order).save }
		
		check_other_stuff try_to_save

		redirect_to user_orders_path(current_user.id)
		# render 'orders/index'
	end


	def check_multiple_tickets_order
		multiple_tickets_amount = @multiple_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount
		if order_params[:multiple_tickets_amount] != "" && (order_params[:multiple_tickets_amount].to_i % 2 != 0 || order_params[:multiple_tickets_amount].to_i > multiple_tickets_amount)
			@order_multiple_hash = nil
			flash[:alert].push("Number of multiple tickets has to be even, and cant be bigger than: #{multiple_tickets_amount}")
		end
	end

	def check_altogether_tickets_order
		altogether_tickets_amount = @altogether_tickets.where(:ticket_type => order_params[:ticket_type]).first.amount
		if order_params[:altogether_tickets_amount] != "" && (altogether_tickets_amount != order_params[:altogether_tickets_amount].to_i || order_params[:altogether_tickets_amount].to_i > altogether_tickets_amount)
			@order_altogether_hash = nil
			flash[:alert].push("You can only buy all at once tickets of type altogether, and cant be bigger than: #{altogether_tickets_amount}")
		end
	end

	def check_avoid_one_tickets_order avoid_one_tickets_amount
		if order_params[:avoid_one_tickets_amount] != "" && ((avoid_one_tickets_amount - order_params[:avoid_one_tickets_amount].to_i) == 1 || order_params[:avoid_one_tickets_amount].to_i > avoid_one_tickets_amount)
			@order_avoid_one_hash = nil
			flash[:alert].push("Avoid one can only be bought so there will be other quantity left than one, and cant be bigger than: #{avoid_one_tickets_amount}")
		end
	end

	def check_other_stuff try_to_save
		if @order_multiple_hash != nil && order_params[:multiple_tickets_amount] != "" &&  try_to_save[0] == false
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
			flash[:success].push("Multiple tickets order saved")
		end
		if try_to_save[1]
			flash[:success].push("Altogether tickets order saved")
		end
		if try_to_save[2]
			flash[:success].push("Avoid one tickets order saved")
		end

		if order_params[:multiple_tickets_amount] == "" && order_params[:altogether_tickets_amount] == "" && order_params[:avoid_one_tickets_amount] == ""
			flash[:alert].push("Nothing saved, form empty")
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

	def check_if_expired
		@orders = Order.where(:user_id => current_user.id).order("created_at DESC")

		@orders.each do |order|
			total_seconds = (Time.now - order.created_at)
			minutes = (total_seconds / 60).floor
		
			if order.state != "paid" && minutes > 15
				order.update(state: "expired")
			end
		end
	end

	# def check_if_amount_is_zero
	# 	if (order_params[:multiple_tickets_amount] != "" && order_params[:multiple_tickets_amount].to_i == 0) || 
	# 		(order_params[:altogether_tickets_amount] != "" && order_params[:altogether_tickets_amount].to_i == 0) || 
	# 		(order_params[:avoid_one_tickets_amount] != "" && order_params[:avoid_one_tickets_amount].to_i == 0)
			
	# 		flash[:alert] = []
	# 		flash[:alert].push("Amount for any type of selling options can't be 0")
	# 		redirect_to user_orders_path(current_user.id)
	# 	end
	# end

	def order_params
		params.require(:order).permit(:user_id, :ticket_id, :bill, :timestamp, :multiple_tickets_amount, :altogether_tickets_amount, :avoid_one_tickets_amount, :ticket_type)
	end
end
