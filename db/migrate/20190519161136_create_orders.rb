class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.integer :amount
      t.decimal :bill
      t.datetime :timestamp

      t.timestamps
    end
  end
end
