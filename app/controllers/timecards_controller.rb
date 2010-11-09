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
    @timecard = Timecard.new()
    project = Project.find(params[:id])
    @timecard.project = project
    timecard_note = TimecardNote.new(:project_id=>"ID!!!")
    @timecard.current_timecards_note = timecard_note
    
    
    if @timecard.save
      redirect_to(@timecard, :notice => 'Timecard was successfully created.')
    else
      render :action => "new"
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
