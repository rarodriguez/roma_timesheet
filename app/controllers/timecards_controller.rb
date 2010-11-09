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
    project = Project.find(params[:id])
    @timecard.project = project
    
    # Calculate initial time
    first_date_week = Time.now.beginning_of_week
    last_date_week = Time.now.end_of_week
    
    timecards = Timecard.where(["(initial_time = ? OR end_time = ?) AND project_id = ?", first_date_week, last_date_week, project.id])
    if(timecards.nil? || timecards.size == 0)
      #    TIMECARD
      #    t.datetime "initial_time"
      #    t.datetime "end_time"
      #    t.integer  "user_id"
      #    t.integer  "project_id"
      #    t.integer  "timecards_note_id"
      #    t.integer  "last_update_by"
      #    t.datetime "created_at"
      #    t.datetime "updated_at"
      
      timecard = Timecard.new(:initial_time)
      #    TIMECARD_NOTE
      #    t.integer  "old_status"
      #    t.integer  "current_status"
      #    t.text     "justification"
      #    t.integer  "timecard_id"
      #    t.integer  "created_by"
      #    t.datetime "created_at"
      #    t.datetime "updated_at"

      timecard_note = TimecardNote.new()
      @timecard.current_timecards_note = timecard_note
      
      if @timecard.save
        redirect_to(@timecard, :notice => 'Timecard was successfully created.')
      else
        render :action => "new"
      end
    else
      
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
