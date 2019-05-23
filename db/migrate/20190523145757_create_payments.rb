class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :order_id
      t.string :hashed_card

      t.timestamps
    end
  end
end
