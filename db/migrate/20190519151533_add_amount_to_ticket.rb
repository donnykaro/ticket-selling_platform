class AddAmountToTicket < ActiveRecord::Migration[5.2]
  def change
  	add_column(:tickets, :amount, :integer)
  end
end
