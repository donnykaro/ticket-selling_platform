class AddParametersToPayment < ActiveRecord::Migration[5.2]
  def change
  	add_column(:payments, :first_name, :string)
  	add_column(:payments, :last_name, :string)
  	add_column(:payments, :expiration_date, :datetime)
  	add_column(:payments, :security_code, :string)
  end
end
