class HistoricalHour < ActiveRecord::Base
  belongs_to :hour
  belongs_to :user, :foreign_key => 'created_by'
end
