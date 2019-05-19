class AddSoldBooleanToTicket < ActiveRecord::Migration[5.2]
  def change
  	add_column(:tickets, :sold, :boolean, default: false)
  end
end
