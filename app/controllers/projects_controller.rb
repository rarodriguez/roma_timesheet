class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    # we suppouse that the security module will only allow to get here if the user have permissions.
    @projects = Project.where(['company_id = ?', params[:company_id]])
    @company = Company.find(params[:company_id])
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    @timecards = Timecard.user_timecards(current_member, @project.id)
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @company_id = params[:company_id]
    @company = Company.find(@company_id)
    @project = Project.new #TODO uncomment :user_id => current_member.id
    @managers = User.includes(:companies).where("companies.id = ?",@company_id)
    @managers = @managers.collect{|man| ["#{man.name} #{man.last_name}",man.id]} if(@managers)
  end

  # GET /projects/1/edit
  def edit
    @company_id = params[:company_id]
    @project = Company.find(@company_id).projects.find(params[:id])
    @managers = User.includes(:companies).where("companies.id = ?",@company_id)
    @managers = @managers.collect{|man| ["#{man.name} #{man.last_name}",man.id]} if(@managers)
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    manager = User.find(params[:project][:user_id])
    @project.manager = manager
    # TODO UNCOMMENT @project.last_updater = current_user
    @project.company = Company.find(params[:company_id])

    if @project.save
      redirect_to(company_project_path(:id=>@project.id, :company_id =>@project.company.id), :notice => 'Project was successfully created.')
    else
      @company_id = params[:company_id]
      @managers = User.includes(:companies).where("companies.id = ?",@company_id)
      @managers = @managers.collect{|man| ["#{man.name} #{man.last_name}",man.id]} if(@managers)
      render :action => "new"
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Company.find(params[:company_id]).projects.find(params[:id])
    manager = User.find(params[:project][:user_id])
    @project.manager = manager
    # TODO UNCOMMENT @project.last_updater = current_user
    if @project.update_attributes(params[:project])
      redirect_to(company_project_path(:id=>@project.id, :company_id =>@project.company.id), :notice => 'Project was successfully updated.')
    else
      @company_id = params[:company_id]
      @managers = User.includes(:companies).where("companies.id = ?",@company_id)
      @managers = @managers.collect{|man| ["#{man.name} #{man.last_name}",man.id]} if(@managers)
      render :action => "edit"
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Company.find(params[:company_id]).projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
