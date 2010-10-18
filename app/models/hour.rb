class Hour < ActiveRecord::Base
  belongs_to :timecard
  has_many :historical_hours
end
