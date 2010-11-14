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
      timecard = Timecard.find(params[:timecard_id])
      # the hour the we should use
      if(params[:oper] == 'edit')
        hour = timecard.hours.find(params[:id])
        # save a historical
        old_information = "Description:#{hour.description}-----Initial Time:#{hour.initial_time}-----End Time:#{hour.end_time}" if(hour)
      else
        hour = Hour.new
      end
      if(hour)
        hour.description = params[:description]
        hour.date = params[:date]
        hour.intime = params[:initial_time]
        hour.entime = params[:end_time]
        hour.timecard = timecard
        if(hour.save)
          if(old_information)
            new_value = "Description:#{hour.description}-----Initial Time:#{hour.initial_time}-----End Time:#{hour.end_time}" 
            HistoricalHour.create(:old_value=>old_information, :new_value=>new_value, :hour_id=>hour.id, :user=>current_member)
          end
          render :json=>"{\"success\":true,\"message\":\"Great! you just added an hour in your timesheet.\"}"
        else
          render :json=>"{\"success\":false,\"message\":\"#{first_error(hour)}\"}"
        end
      else
        render :json=>"{\"success\":false,\"message\":\"Oops, you tried to do an invalid operation.\"}"
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
    render :json=>"{\"success\":true}"
  end
end
