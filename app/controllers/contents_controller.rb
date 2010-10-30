class ContentsController < ApplicationController
  def dashboard
    my_timecards
    my_companies
  end
  
  private 
  def my_timecards
    # timecards = current_user.timecards
    timecards = Timecard.all
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
    
    @timecards = timecards_param.to_local_jqgrid_hash([:id, :company, :project, :total_hours, :initial_time, :end_time, :details])
  end
  
  def my_companies
    # We can only allow access if the user is the owner of the company
    # current_user.companies
    companies = Company.all
    companies_param = []
    companies.each do |comp|
      comp_hash = {}
      comp_hash[:id] = comp.id
      comp_hash[:name] = comp.name
      comp_hash[:total_projects] = comp.projects.count
      total_hours = 0
      comp.timecards.each{|tc| total_hours += tc.total_hours}
      comp_hash[:total_hours] = total_hours && total_hours != '' ? total_hours : 0
      comp_hash[:total_employees] = comp.users.count
      comp_hash[:details] = "Details"
      companies_param << comp_hash
    end
    
    @projects = companies_param.to_local_jqgrid_hash([:id,:name,:total_projects,:total_employees,:total_hours,:details])
  end
end
