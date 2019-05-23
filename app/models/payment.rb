class Payment < ApplicationRecord
	belongs_to :user
	belongs_to :order

	validates :user_id, :order_id, :hashed_card, :bill, presence: true
end
