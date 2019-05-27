class Event < ApplicationRecord
	has_many :tickets

	validates_presence_of :name, :date_time, :description
end
