class AddBillToPayment < ActiveRecord::Migration[5.2]
  def change
  	add_column(:payments, :bill, :decimal)
  end
end
