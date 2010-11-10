class TimecardsController < ApplicationController
  # GET /timecards
  # GET /timecards.xml
  def index
    @timecards = Timecard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timecards }
    end
    
  end

  # GET /timecards/1
  # GET /timecards/1.xml
  def show
    @timecard = Timecard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timecard }
    end
  end
  
  def add_hours
    @timecard = Timecard.new
  end

  # GET /timecards/new
  # GET /timecards/new.xml
  #def new
  #  @timecard = Timecard.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @timecard }
  #  end
  #end

  # GET /timecards/1/edit
  def edit
    @timecard = Timecard.find(params[:id])
  end

  # POST /timecards
  # POST /timecards.xml
  def create
    @timecard = Timecard.new
    project = Project.find(params[:project_id])
    @timecard.project = project
    
    # Calculate initial time
    first_date_week = Time.now.beginning_of_week
    last_date_week = Time.now.end_of_week
    
    old_timecard = Timecard.where(["(initial_time = ? OR end_time = ?) AND project_id = ?", first_date_week, last_date_week, project.id]).limit(1)
    # The user don't have any timecard for this week on the application.
    if(old_timecard.nil? || old_timecard.size == 0)
      @timecard.initial_time = first_date_week
      @timecard.end_time = last_date_week
      @timecard.user_id = 1
      #@timecard.user = current_member
      @timecard.last_update_by = 1
      #@timecard.last_updater = 1
      begin
        Timecard.transaction do
          @timecard.save!
          @timecard.timecards_notes << TimecardsNote.new(:current_status=>PROCESS, :timecard=>@timecard, :creator=>current_member)
        end
        render :action => "edit"
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace
        redirect_to(projects_path(:company_id=>project.company_id,:id=>project.id), :notice => "We couldn't create a new timecard for your account. Please try again.")
      end
    else
      old_timecard = old_timecard.first
      if(old_timecard.current_timecards_note.current_status == PROCESS)
        @timecard = old_timecard
        render :action => "edit"
      else
        redirect_to(company_project_path(:company_id=>project.company_id,:id=>project.id), :notice => "You already created and submit a timecard for this week. You can create another next week.")
      end
    end
  end

  # PUT /timecards/1
  # PUT /timecards/1.xml
  def update
    @timecard = Timecard.find(params[:id])

    respond_to do |format|
      if @timecard.update_attributes(params[:timecard])
        format.html { redirect_to(@timecard, :notice => 'Timecard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @timecard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timecards/1
  # DELETE /timecards/1.xml
  def destroy
    @timecard = Timecard.find(params[:id])
    @timecard.destroy

    respond_to do |format|
      format.html { redirect_to(timecards_url) }
      format.xml  { head :ok }
    end
  end
end
