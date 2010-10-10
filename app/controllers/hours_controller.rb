class HoursController < ApplicationController
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
    @hour = Hour.new(params[:hour])

    respond_to do |format|
      if @hour.save
        format.html { redirect_to(@hour, :notice => 'Hour was successfully created.') }
        format.xml  { render :xml => @hour, :status => :created, :location => @hour }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hour.errors, :status => :unprocessable_entity }
      end
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
