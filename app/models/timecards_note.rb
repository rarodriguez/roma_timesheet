class TimecardsNote < ActiveRecord::Base
  has_one :timecard
  belongs_to :creator, :class_name => "User", :foreign_key=> 'created_by'
end
