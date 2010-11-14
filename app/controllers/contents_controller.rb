class ContentsController < ApplicationController
  def dashboard
    @timecards = Timecard.user_timecards(current_member)
    @companies = Company.user_companies(current_member)
    @projects = Project.user_projects(current_member)
    @projects.each do |proj|
      params[:project_id] = proj[:id]
      can_add_timecards = has_permission?("timecards","create", params)
      proj[:add_timeshee] = can_add_timecards
    end
    puts "######### ME LLEVA LA CHIN...  "
    puts @projectss.inspect
    @projects = @projects.to_local_jqgrid_hash([:id,:project,:company_id,:registered_hours,:total_timesheets,:view_timesheets,:add_timesheet])
    @dashboard = true
  end
  
end
