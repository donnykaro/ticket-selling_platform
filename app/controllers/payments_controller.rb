class PaymentsController < ApplicationController
	def new
		@order = Order.find(params[:order_id])
		@event = @order.ticket.event
		@payment = Payment.new
	end

	def create
		# @order = Order.find(params[:order_id])
		@payment = Payment.new(payment_params)

		if @payment.save
			flash[:notice] = "payment successful"
			@payment.order.update(state: "paid")
			redirect_to events_path
		else
			flash[:alert] = @payment.errors
			render 'new'
		end
	end

	private

	def payment_params
		params.require(:order).permit(:user_id, :order_id, :hashed_card)
	end
end
