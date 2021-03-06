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
    @manager = has_permission?("timecards","index",{:project_id=>@project.id})
    if(@manager)
      @project_timecards = Timecard.project_timecards @project, current_member.id
      # check permissions
      @project_timecards.each do |time|
        time[:edit] = has_permission?("timecards", "edit", {:project_id=>@project.id, :id=>time.id}) ? time[:edit] : ''
      end
      @employees_timecards_size = @project_timecards.size 
      @project_timecards = @project_timecards.to_local_jqgrid_hash([:id, :company, :project, :status, :total_hours, :initial_time, :end_time, :employee, :details, :edit])
    end 
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @company_id = params[:company_id]
    @company = Company.find(@company_id)
    @project = Project.new #TODO uncomment :user_id => current_member.id
    @project.company_id = @company.id
    @default_manager = current_member.id
    @employees = User.cb_all_by_company_id(@company_id)
  end

  # GET /projects/1/edit
  def edit
    @company_id = params[:company_id]
    @company = Company.find(@company_id)
    @project = @company.projects.find(params[:id])
    @current_employees = @project.employees.collect{|emp|emp.id}
    @employees = User.cb_all_by_company_id(@company_id)
  end

  # POST /projects
  # POST /projects.xml
  def create
    @company = Company.find(params[:company_id])
    project_params = params[:project]
    manager = @company.users.find(project_params[:user_id])
    
    generate_employees manager, project_params
    
    @project = Project.new(project_params)
    @project.manager = manager
    @project.last_updater = current_member
    @project.company = @company

    if(@project.valid?)
      begin
        Project.transaction do
          @project.save!
          project_role = Role.find_by_name("project_manager")
          # if the user have just one project
          if(manager.projects && manager.projects.size == 1)
            manager.roles << project_role
          end 
        end
        redirect_to(company_project_path(:id=>@project.id, :company_id =>@company.id), :notice => 'Project was successfully created.')
      rescue Exception=>e
        logger.error e.message
        logger.error e.backtrace
        @company_id = params[:company_id]
        @employees = User.cb_all_by_company_id(@company_id)
        render :action => "new"
      end
    else
      @company_id = params[:company_id]
      @employees = User.cb_all_by_company_id(@company_id)
      render :action => "new"
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    project_params = params[:project]
    manager = User.find(project_params[:user_id])
    
    generate_employees manager, project_params
    
    old_project_manager = @project.manager
    @project.manager = manager
    @project.last_updater = current_member
    
    if @project.update_attributes(params[:project])
      # if the manager changes
      if(old_project_manager != @project.manager)
        project_role = Role.find_by_name("project_manager")
        #handle the role for the old manager
        old_project_manager.roles.delete if(old_project_manager.projects.nil? || old_project_manager.projects.size < 1)
        # if the new manager  
        manager.roles << project_role if(manager.projects && manager.projects.size == 1)
      end
      redirect_to(company_project_path(:id=>@project.id, :company_id =>@project.company.id), :notice => 'Project was successfully updated.')
    else
      @company_id = params[:company_id]
      @employees = User.cb_all_by_company_id(@company_id)
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
  
  private
  def generate_employees manager, project_params
    project_params.delete(:user_id)
    if(manager && project_params[:employees] && project_params[:employees].size > 0)
      project_params[:employees] = User.all_by_company_and_ids_and_not_manager @company, project_params[:employees], manager
    else
      project_params[:employees] = []
    end
    project_params[:employees] << manager 
  end

end
