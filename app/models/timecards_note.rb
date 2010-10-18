class TimecardsNote < ActiveRecord::Base
  has_one :timecard
  has_one :creator, :class_name => "User", :foreign_key=> 'created_by'
end
