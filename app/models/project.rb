class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :manager, :class_name => "User", :foreign_key=>'user_id'
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'  
  belongs_to :company
  has_many :timecards
  has_many :hours, :through => :timecards
  
  validates_presence_of :name, :message=>"Oops, you can't proceed until you enter your project's name."
  validates_length_of :name, :maximum => 100, :message=>"Oops, your project's name is too long. The maximum length is 100 characters."
  
  validates_presence_of :manager, :message=>"Oops, you can't proceed until you select a manager for your project."
  validates_presence_of :company, :message=>"Oops, you can't proceed until you select a valid company for your project."
  
  def self.user_projects(user)
    # We should only allow access if the user is the owner of the company
    # projects = user.projects
    projects = self.all
    projects_param = []
    projects.each do |proj|
      proj_hash = {}
      proj_hash[:id] = proj.id
      proj_hash[:project] = proj.name
      # timecards = Timecard.where(["timecards.project_id = ? AND timecards.user_id = ?", proj.id, user.id]) 
      timecards = proj.timecards
      total_hours = 0
      timecards.each{|tc| total_hours += tc.total_hours}
      proj_hash[:registered_hours] = total_hours && total_hours != '' ? total_hours : 0
      proj_hash[:total_timesheets] = proj.timecards.size
      proj_hash[:view_timesheets] = "View Timesheets"
      proj_hash[:add_timesheet] = "Add Timesheet"
      projects_param << proj_hash
    end
    projects_param.to_local_jqgrid_hash([:id,:project,:registered_hours,:total_timesheets,:view_timesheets,:add_timesheet])
  end
end
