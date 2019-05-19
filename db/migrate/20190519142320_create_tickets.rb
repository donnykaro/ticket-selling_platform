class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :event_id
      t.string :ticket_type

      t.timestamps
    end
  end
end
