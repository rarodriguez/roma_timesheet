class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])
    @can_edit_company = has_permission?("companies","edit", params)
    params[:company_id] = params[:id]
    @can_add_project = has_permission?("projects","new", params)
    @projects = Project.user_projects(current_member)
    @projects.each do |proj|
      params[:project_id] = proj[:id]
      can_add_timecards = has_permission?("timecards","create", params)
      proj[:add_timesheet] = can_add_timecards
    end
    @projects = @projects.to_local_jqgrid_hash([:id,:project,:registered_hours,:total_timesheets,:view_timesheets,:add_timesheet])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])
    @company.manager = current_member
    if @company.save
      
      redirect_to(@company, :notice => 'Company was successfully created.')
    else
      render :action => "new"
      render :xml => @company.errors, :status => :unprocessable_entity
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'Company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end
end
