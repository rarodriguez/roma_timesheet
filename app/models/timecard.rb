class Timecard < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :current_timecards_note, :class_name=>"TimecardsNote", :foreign_key=>'timecards_note_id'
  has_many :timecards_notes
  has_many :hours
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'
  
  validates_presence_of :initial_time, :message=>"Oops, your didn't typed an initial time"
  validates_presence_of :end_time, :message=>"Oops, your didn't typed an end time"
  #validates_presence_of :current_timecards_note, :message=>"Oops, you didn't added any note for the timesheet"
  
  def total_hours
    total_hours = 0
    self.hours.each{|hr| total_hours += hr.end_time - hr.initial_time}
    #gets the hours with only 2 decimals
    (((total_hours/3600)*100).to_i)/100.0
  end
  
  def self.user_timecards(user, project_id = 0)
    if(project_id > 0)
      timecards = self.where("project_id = ?", project_id)
      #timecards = user.timecards.where("project_id = ?", project_id)
    else
      # timecards = user.timecards
      timecards = self.all
    end
    timecards_param = []
    timecards.each do |timecard|
      time_hash = {}
      time_hash[:id] = timecard.id
      time_hash[:company] = timecard.project.company.name
      time_hash[:project] = timecard.project.name
      time_hash[:total_hours] = timecard.total_hours
      time_hash[:initial_time] = timecard.initial_time.strftime("%x %X")
      time_hash[:end_time] = timecard.end_time.strftime("%x %X")
      time_hash[:details] = timecard.id
      time_hash[:edit] = timecard.id
      timecards_param << time_hash
    end
    timecards_param.to_local_jqgrid_hash([:id, :company, :project, :total_hours, :initial_time, :end_time, :details, :edit])
  end
  
  private
  
  def ranges_of_dates
    if(self.initial_time && self.end_time)
      if(self.initial_time > self.end_time)
        self.errors.add(:end_time, "End time should be greater than initial time.")
      end
    end
  end
end
