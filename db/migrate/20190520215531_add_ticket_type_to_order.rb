class AddTicketTypeToOrder < ActiveRecord::Migration[5.2]
  def change
  	add_column(:orders, :ticket_type, :string)
  end
end
