module SecurityManager
  
  #Method of before_filter
  def validate_access_sec (controller, action, params)
    if (current_member && current_member.password_changed_at)
      return has_permission?(controller, action, params)
    end
    false
  end
  
  # Generic method to validate the actions of the user in the controller
  def has_permission? (controller, action, params)
    if (controller && action)
      action = "#{controller}_#{action}"
      action.gsub!(/\W+/, "")
      roles = current_member.roles
      roles.each do |role|
        permission = role.permissions.where(["name = ?", action]).first
        if (permission && permission.name == action)
          if (permission.needs_extra_validation)
            proc = lambda { params; binding }
            return eval("#{action}_validation params ", proc.call)
          end
          return true
        end      
      end
    end
    return false  
  end  
  
  def is_company_manager? company_id
    company = current_member.managed_companies.where(["id = ?", company_id]).first
    if(company_id && company)
      return true
    end
    false
  end
  
  def is_company_member? company_id
    company = current_member.companies.where(["id = ?", company_id]).first
    if(company_id && company)
      return true
    end
    false
  end
  
  def is_project_manager? project_id
    project = current_member.managed_projects.where(["id = ?", project_id]).first
    if(project_id && project)
      return true
    end
    false
  end
  
  def is_project_member? project_id
    project = current_member.projects.where(["id = ?", project_id]).first
    if(project_id && project)
      return true
    end
    false
  end
  
  
  ## Specific extra validation methods ##
  
  ##
  # Companies
  ##
  def companies_edit_validation params
    #Company Manager
    return is_company_manager? params[:id]
  end
  def companies_update_validation params
    companies_edit_validation params
  end
  def companies_destroy_validation params
    companies_edit_validation params
  end
  
  def companies_show_validation params
    #Company Manager
    company_manager = is_company_manager? params[:id]
    #Company Member
    company_member = is_company_member? params[:id]
    return company_manager || company_member 
  end
  ##################################################
  
  
  ##
  # Projects
  ##
  def projects_new_validation params
    #Company Manger
    return is_company_manager? params[:company_id]
  end
  def projects_create_validation params
    return projects_new_validation params
  end
  def projects_destroy_validation params
    projects_new_validation params
  end
  
  def projects_edit_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Project Manager
    project_manager = is_project_manager? params[:id]
    return company_manager || project_manager
  end
  def projects_update_validation params
    projects_edit_validation params
  end
  
  def projects_show_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Project Member
    project_member = is_project_member? params[:id]
    return company_manager || project_member
  end
  
  def projects_index_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Company Member
    project_member = is_project_member? params[:company_id]
    return company_manager || project_member
  end
  ##################################################
  
  
  ##
  # User
  ##
  def users_new_validation params
    #company Manager
    return is_company_manager? params[:company_id]
  end
  def users_create_validation params
    return projects_new_validation params
  end
  
  def users_edit_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Owner
    owner = params[:id] && current_member.id == params[:id].to_i
    return company_manager || owner
  end
  def users_update_validation params
    users_edit_validation params
  end
  def users_destroy_validation params
    users_edit_validation params
  end
  
  def users_show_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Project Manager
    project_manager = is_project_manager? params[:project_id]
    #Owner
    owner = params[:id] && current_member.id == params[:id].to_i
    return company_manager || project_manager || owner
  end
  
  def users_index_validation params
    #Company Manager
    company_manager = is_company_manager? params[:company_id]
    #Project Memeber
    project_member = is_project_member? params[:project_id]
    #Owner
    owner = params[:id] && current_member.id == params[:id].to_i
    return company_manager || project_member || owner
  end
  ##################################################
  
  
  ##
  # Timecard
  ##
  #deprecated#def timecards_add_hours_validation params
  #  #Project Member
  #  return is_project_member? params[:project_id]
  #end
  def timecards_create_validation params
    #Project Member
    return is_project_member? params[:project_id]
  end
  
  def timecards_edit_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
      
      #Owner
      project_member = is_project_member? params[:project_id]
      owner = project_member && timecard.user == current_member && (timecard_status == PROCESS || timecard_status == REJECT)    
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.user != current_member && (timecard_status == REVISION || timecard_status == ACCEPT)
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      comp_manager = company_manager && timecard.user == timecard.project.manager && (timecard_status == REVISION || timecard_status == ACCEPT)
      
      return owner || proj_manager || comp_manager
    end
    false
  end
  #deprecated#def timecards_update_validation params
  #  timecards_edit_validation params
  #end
  #deprecated#def timecards_destroy_validation params
  #  timecards_edit_validation params
  #end
  
  def timecards_process_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
      
      #Owner
      project_member = is_project_member? params[:project_id]
      return  project_member && timecard.user == current_member && timecard_status == REJECT
    end
    false
  end
  
  def timecards_revision_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
      
      #Owner
      project_member = is_project_member? params[:project_id]
      return  project_member && timecard.user == current_member && timecard_status == PROCESS
    end
    false
  end
  
  def timecards_reject_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
          
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.user != current_member && (timecard_status == REVISION || timecard_status == ACCEPT)
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      comp_manager = company_manager && timecard.user == timecard.project.manager && (timecard_status == REVISION || timecard_status == ACCEPT)
      
      return proj_manager || comp_manager
    end
    false
  end
  
  def timecards_accept_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
          
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.user != current_member && timecard_status == REVISION
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      comp_manager = company_manager && timecard.user == timecard.project.manager && timecard_status == REVISION
      
      return proj_manager || comp_manager
    end
    false
  end
  
  def timecards_finished_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)
      timecard_status = timecard.current_timecards_note.current_status
          
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.user != current_member && timecard_status == ACCEPT
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      comp_manager = company_manager && timecard.user == timecard.manager && timecard_status == ACCEPT
      
      return proj_manager || comp_manager
    end
    false
  end 
  
  def timecards_show_validation params
    timecard = Timecard.where(["id = ?", params[:id]]).first
    if(timecard)      
      #Owner
      project_member = is_project_member? params[:project_id]
      owner = project_member && timecard.user == current_member
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      proj_manager = project_manager && timecard.project.manager == current_member
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      
      return owner || proj_manager || company_manager
    end
    false
  end 
  def timecards_index_validation params
    project = Project.where(["id = ?", params[:project_id]]).first
    if(project)
      #Project Manager
      project_manager = is_project_manager? params[:project_id]
      #Company Manager
      company_manager = is_company_manager? params[project.company.id]
      
      return project_manager || company_manager
    end
    false
  end 
  ##################################################
  
  
  ##
  # Hours
  ##
  def hours_create_validation params
    hour = Hour.where(["id = ?", params[:id]]).first
    if(hour)
      timecard = hour.timecard
      
      #Owner
      project_member = is_project_member? timecard.project.id
      owner = project_member && timecard.user == current_member && timecard.id == params[:timecard_id] 
      #Project Manager
      project_manager = is_project_manager? timecard.project.id
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.id == params[:timecard_id]
      
      return owner || proj_manager
    end
    false
  end
  def hours_destroy_validation params
    hours_create_validation params
  end
  
  def hours_index_validation params
    hour = Hour.where(["id = ?", params[:id]]).first
    if(hour)
      timecard = hour.timecard
      
      #Owner
      project_member = is_project_member? timecard.project.id
      owner = project_member && timecard.user == current_member && timecard.id == params[:timecard_id] 
      #Project Manager
      project_manager = is_project_manager? timecard.project.id
      proj_manager = project_manager && timecard.project.manager == current_member && timecard.id == params[:timecard_id]
      #Company Manager
      company_manager = is_company_manager? params[timecard.project.company.id]
      
      return (owner || proj_manager || company_manager) && timecard.id == params[:timecard_id]
    end
    false
  end
  ##################################################
    
end