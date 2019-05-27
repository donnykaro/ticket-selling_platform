class PaymentsController < ApplicationController
	before_action :get_order_and_event, only: [:new, :create]

	def new
		@payment = Payment.new
	end

	def create
		# @order = Order.find(params[:order_id])
		local_params = payment_params
		encrypt_data payment_params[:hashed_card]
		local_params[:hashed_card] = @encrypted_card 
		@payment = Payment.new(local_params)
		
		total_seconds = (Time.now - @payment.order.created_at)
		minutes = (total_seconds / 60).floor

		expired_flag = false
		if minutes > 15 || @payment.order.state == "expired"
			expired_flag = true
			if @payment.order.state == "reserved"
				@payment.order.update(state: "expired")
			end
			@payment = Payment.new(nil)
		end

		if @payment.save
			flash[:success] = "Payment successful"
			@payment.order.update(state: "paid")
			amount = 0
			if @payment.order.multiple_tickets_amount != ""
				amount = @payment.order.multiple_tickets_amount.to_i
			end
			if @payment.order.altogether_tickets_amount != ""
				amount = @payment.order.altogether_tickets_amount.to_i
			end
			if @payment.order.avoid_one_tickets_amount != ""
				amount = @payment.order.avoid_one_tickets_amount.to_i
			end
			@payment.order.ticket.update(amount: (@payment.order.ticket.amount - amount))
			redirect_to user_orders_path(current_user.id)
		else
			if expired_flag
				flash[:alert] = "The order has expired"
				redirect_to user_orders_path(current_user.id)
			else
				flash[:alert] = @payment.errors
				render 'new'
			end
		end
	end

	def encrypt_data data
		data = data.to_s unless data.is_a? String

		len   = ActiveSupport::MessageEncryptor.key_len
	  salt  = SecureRandom.hex len
	  key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
	  crypt = ActiveSupport::MessageEncryptor.new key
	  @encrypted_card = crypt.encrypt_and_sign data
	end

	def decrypt_data data
	end

	private

	def get_order_and_event
		@order = Order.find(params[:order_id])
		@event = @order.ticket.event
	end

	def payment_params
		params.require(:payment).permit(:user_id, :order_id, :bill, :hashed_card, :first_name, :last_name, :expiration_date, :security_code)
	end
end
