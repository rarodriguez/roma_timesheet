class ContentsController < ApplicationController
  def dashboard
    @timecards = Timecard.user_timecards(current_member)
    @companies = Company.user_companies(current_member)
    @projects = Project.user_projects(current_member)
  end
  
end
