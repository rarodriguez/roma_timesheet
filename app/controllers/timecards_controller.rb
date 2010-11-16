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
    project = Project.find(params[:project_id])
    @timecard = project.timecards.find(params[:id])
    @can_edit_timecard = has_permission?("timecards", "edit", params)
    #@can_edit_timecard = true
  end

  # GET /timecards/1/edit
  def edit
    project = Project.find(params[:project_id])
    @timecard = project.timecards.find(params[:id])
    @can_edit_timecard = has_permission?("timecards", "edit", params)
    @can_process_timecard = has_permission?("timecards", "process", params)
    @can_accept_timecard = has_permission?("timecards", "accept", params)
    @can_reject_timecard = has_permission?("timecards", "reject", params)
    @can_revision_timecard = has_permission?("timecards", "revision", params)
    @can_finished_timecard = has_permission?("timecards", "finished", params)
    #@can_edit_timecard = true
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
      #@timecard.user_id = 1
      @timecard.user = current_member
      #@timecard.last_update_by = 1
      @timecard.last_updater = current_member
      begin
        Timecard.transaction do
          @timecard.save!
          timecard_note = TimecardsNote.create(:current_status=>PROCESS, :timecard_id=>@timecard.id, :creator=>current_member)
          @timecard.current_timecards_note=timecard_note
        end
        redirect_to edit_timecard_path(:project_id=>@timecard.project_id, :id=>@timecard.id)
        #render :action => "edit"
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace
        redirect_to(company_project_path(:company_id=>project.company_id,:id=>project.id), :notice => "We couldn't create a new timecard for your account. Please try again.")
      end
    else
      old_timecard = old_timecard.first
      if(old_timecard.current_timecards_note && old_timecard.current_timecards_note.current_status == PROCESS)
        @timecard = old_timecard
        redirect_to edit_timecard_path(:project_id=>@timecard.project_id, :id=>@timecard.id)
        #render :action => "edit"
      else
        redirect_to(company_project_path(:company_id=>project.company_id,:id=>project.id), :notice => "You already created and submit a timecard for this week. You can create another next week.")
      end
    end
  end
  
  def change_state
    valid_xhr_request?
    
    action = params[:change_to]
    action.downcase
    case action
    when "process"
      state = PROCESS
    when "revision"
      state = REVISION
    when "reject"
      state = REJECT
    when "accept"
      state = ACCEPT
    when "finished"
      state = FINISHED
    else
      state = -1
    end
    if(has_permission?("timecards", action, params))
      change_state_to(PROCESS, params)
    else
      render :json=>"{\"success\":false,\"message\":\"You can't change the state of the timecard right now.\"}"
    end
  end
  
  private
  def change_state_to (status, params)
    @timecard = current_member.timecards.find(params[:id])
    if(@timecard && status > -1)
      old_note = @timecard.current_timecards_note
      @timecard.last_updater = current_member
      status_name = timecards_status_name status
      begin
        Timecard.transaction do
          @timecard.save!
          timecards_note = TimecardsNote.create(:current_status=>status, :old_status=>old_note.current_status , :timecard=>@timecard, :creator=>current_member)
          @timecard.current_timecards_note = timecards_note
        end
        render :json=>"{\"success\":true,\"message\":\"The timecard is now in a state of #{status_name}.\"}"
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace
        render :json=>"{\"success\":false,\"message\":\"We couldn't change timecard's state. Please try again.\"}"
      end
    end
  end 

#  # PUT /timecards/1
#  # PUT /timecards/1.xml
#  def update
#    @timecard = Timecard.find(params[:id])
#
#    respond_to do |format|
#      if @timecard.update_attributes(params[:timecard])
#        format.html { redirect_to(@timecard, :notice => 'Timecard was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @timecard.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

#  # DELETE /timecards/1
#  # DELETE /timecards/1.xml
#  def destroy
#    @timecard = Timecard.find(params[:id])
#    @timecard.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(timecards_url) }
#      format.xml  { head :ok }
#    end
#  end
end
