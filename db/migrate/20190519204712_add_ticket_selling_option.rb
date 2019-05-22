class AddTicketSellingOption < ActiveRecord::Migration[5.2]
  def change
  	add_column(:tickets, :selling_option, :string)
  end
end
