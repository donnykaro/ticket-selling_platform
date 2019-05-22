class Order < ApplicationRecord
	belongs_to :user
	belongs_to :ticket

	#validation
	validates :user_id, :ticket_id, :bill, :timestamp, :status, :ticket_type,  presence: true
	validates :user_id, numericality: true
	validates :ticket_id, numericality: true
	validates :bill, numericality: true
end
