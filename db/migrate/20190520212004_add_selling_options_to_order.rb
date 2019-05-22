class AddSellingOptionsToOrder < ActiveRecord::Migration[5.2]
  def change
  	add_column(:orders, :multiple_tickets_amount, :string)
  	add_column(:orders, :altogether_tickets_amount, :string)
  	add_column(:orders, :avoid_one_tickets_amount, :string)
  end
end
