class Timecard < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :current_timecards_note, :class_name=>"TimecardsNote"
  has_many :timecards_notes
  has_many :hours
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'
  
  def total_hours
    total_hours = 0
    self.hours.each{|hr| total_hours += hr.end_time - hr.initial_time}
    #gets the hours with only 2 decimals
    
    (((total_hours/3600)*100).to_i)/100.0
  end
end
