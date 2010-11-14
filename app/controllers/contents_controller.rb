class ContentsController < ApplicationController
  def dashboard
    @timecards = Timecard.user_timecards(current_member)
    @companies = Company.user_companies(current_member)
    @projects = Project.user_projects(current_member)
    @projects.each do |proj|
      params[:project_id] = proj.id
      can_add_timecards = has_permission?("timecards","create", params)
      proj.add_timesheet = can_add_timecards
    end
    @projects = @projects.to_local_jqgrid_hash([:id,:project,:registered_hours,:total_timesheets,:view_timesheets,:add_timesheet])
    @dashboard = true
  end
  
end
