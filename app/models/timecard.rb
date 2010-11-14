class Timecard < ActiveRecord::Base
  
  # Includes Security
  include SecurityManager
  
  belongs_to :project
  belongs_to :user
  #belongs_to :current_timecards_note, :class_name=>"TimecardsNote", :foreign_key=>'timecards_note_id'
  has_many :timecards_notes
  has_many :hours
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'
  
  validates_presence_of :initial_time, :message=>"Oops, your didn't typed an initial time"
  validates_presence_of :end_time, :message=>"Oops, your didn't typed an end time"
  #validates_presence_of :current_timecards_note, :message=>"Oops, you didn't added any note for the timesheet"
  
  def current_timecards_note
    TimecardsNote.find(self.timecards_note_id) if(self.timecards_note_id)
  end
  def current_timecards_note= timecard_note
    if(timecard_note)
      self.timecards_note_id = timecard_note.id
      self.save
    end
  end
  
  def total_hours
    total_hours = 0
    self.hours.each{|hr| total_hours += hr.end_time - hr.initial_time}
    #gets the hours with only 2 decimals
    (((total_hours/3600)*100).to_i)/100.0
  end
  
  def self.user_timecards(user, project_id = 0)
    if(project_id > 0)
      #timecards = self.where("project_id = ?", project_id)
      timecards = user.timecards.where("project_id = ?", project_id)
    else
      timecards = user.timecards
      #timecards = self.all
    end
    timecards_param = timecard_local timecards
    timecards_param.to_local_jqgrid_hash([:id, :company, :project, :project_id, :status, :total_hours, :initial_time, :end_time, :employee, :details, :edit])
  end
  
  def self.project_timecards(project, user_id)
    timecards = Timecard.where(["project_id = ? AND user_id != ?",project.id, user_id]).order("end_time DESC")
    timecard_local timecards
  end
  
  def status_name
    if(self.current_timecards_note)
      case self.current_timecards_note.current_status
      when PROCESS
        "Process"
      when REVISION
        "Under Review"
      when REJECT
        "Rejected"
      when ACCEPT
        "Accepted"
      when FINISHED
        "Finished"
      else
        "New Timecard"
      end
    end
  end
  
  private
  
  def ranges_of_dates
    if(self.initial_time && self.end_time)
      if(self.initial_time > self.end_time)
        self.errors.add(:end_time, "End time should be greater than initial time.")
      end
    end
  end
  
  def self.timecard_local timecards
    timecards_param = []
    timecards.each do |timecard|
      time_hash = {}
      time_hash[:id] = timecard.id
      time_hash[:company] = timecard.project.company.name
      time_hash[:project] = timecard.project.name
      time_hash[:project_id] = timecard.project.id
      time_hash[:status] = timecard.status_name
      time_hash[:total_hours] = timecard.total_hours
      time_hash[:initial_time] = timecard.initial_time.strftime("%x %H:%M")
      time_hash[:end_time] = timecard.end_time.strftime("%x %H:%M")
      time_hash[:employee] = "#{timecard.user.name} #{timecard.user.last_name}"
      time_hash[:details] = ""
      time_hash[:edit] = timecard.id 
      timecards_param << time_hash
    end
    timecards_param
  end
end
