class RemoveTicketTypeAddDescriptionToEvent < ActiveRecord::Migration[5.2]
  def change
  	remove_column(:events, :ticket_type)
  	add_column(:events, :description, :text)
  end
end
