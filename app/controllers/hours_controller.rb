class HoursController < ApplicationController
  
  before_filter :valid_xhr_request?, :only=>:create
  # GET /hours
  # GET /hours.xml
  def index
    @timecard = Timecard.find(params[:timecard_id])
    render :json => Hour.timecard_hours(@timecard)
  end

  # POST /hours
  # POST /hours.xml
  def create
    if(params[:oper] && params[:oper] != '')
      # the hour the we should use
      hour = params[:oper] == 'edit' ? Hour.find(params[:id]) : Hour.new
      hour.description = params[:description]
      hour.date = params[:date]
      hour.intime = params[:initial_time]
      hour.entime = params[:end_time]
      hour.timecard = Timecard.find(params[:timecard_id])
      if(hour.save)
        render :json=>"{\"success\":true,\"message\":\"Great! you just added an hour in your timesheet.\"}"
      else
        render :json=>"{\"success\":false,\"message\":\"#{first_error(hour)}\"}"
      end
    else
      render :json=>"{\"success\":false,\"message\":\"Oops, you tried to do an invalid operation.\"}"
    end
  end

  # DELETE /hours/1
  # DELETE /hours/1.xml
  def destroy
    @hour = Hour.find(params[:id])
    @hour.destroy
    render :json=>"{\"success\":false}"
  end
end
