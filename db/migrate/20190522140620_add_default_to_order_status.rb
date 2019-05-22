class AddDefaultToOrderStatus < ActiveRecord::Migration[5.2]
  def change
  	change_column :orders, :status, :string, default: "reserved"
  end
end
