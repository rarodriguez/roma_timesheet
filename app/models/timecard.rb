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
  
  def self.user_timecards(user)
    # timecards = user.timecards
    timecards = self.all
    timecards_param = []
    timecards.each do |timecard|
      time_hash = {}
      time_hash[:id] = timecard.id
      time_hash[:company] = timecard.project.company.name
      time_hash[:project] = timecard.project.name
      time_hash[:total_hours] = timecard.total_hours
      time_hash[:initial_time] = timecard.initial_time.strftime("%x %X")
      time_hash[:end_time] = timecard.end_time.strftime("%x %X")
      time_hash[:details] = "Details"
      timecards_param << time_hash
    end
    
    timecards_param.to_local_jqgrid_hash([:id, :company, :project, :total_hours, :initial_time, :end_time, :details])
  end
end
