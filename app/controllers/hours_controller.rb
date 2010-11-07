class HoursController < ApplicationController
  
  before_filter :valid_xhr_request?, :only=>:create
  # GET /hours
  # GET /hours.xml
  def index
    @hours = Hour.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hours }
    end
  end

  # GET /hours/1
  # GET /hours/1.xml
  def show
    @hour = Hour.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hour }
    end
  end

  # GET /hours/new
  # GET /hours/new.xml
  def new
    @hour = Hour.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hour }
    end
  end

  # GET /hours/1/edit
  def edit
    @hour = Hour.find(params[:id])
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

  # PUT /hours/1
  # PUT /hours/1.xml
  def update
    @hour = Hour.find(params[:id])

    respond_to do |format|
      if @hour.update_attributes(params[:hour])
        format.html { redirect_to(@hour, :notice => 'Hour was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hour.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hours/1
  # DELETE /hours/1.xml
  def destroy
    @hour = Hour.find(params[:id])
    @hour.destroy

    respond_to do |format|
      format.html { redirect_to(hours_url) }
      format.xml  { head :ok }
    end
  end
end
