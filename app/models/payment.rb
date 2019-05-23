class Payment < ApplicationRecord
	belongs_to :user
	has_one :order

	validates :user_id, :order_id, :hashed_card, presence: true
end
