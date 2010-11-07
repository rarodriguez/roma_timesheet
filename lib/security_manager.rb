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
          puts "PERMISSIONS #{permission.name}"
          if (permission.needs_extra_validation)
            proc = lambda { params; binding }
            return eval("#{action}_validation params ", proc.call)
          end
          return true
        end
        
      end
    end
    false  
  end  
  
  
  ## Specific extra validation methods ##
  
  ##
  # Companies
  ##
  def companies_edit_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    false
  end
  def companies_update_validation params
    companies_edit_validation params
  end
  
  def companies_show_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    company = current_member.companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    false
  end
  ##################################################
  
  
  ##
  # Projects
  ##
  def projects_new_validation params
    puts "PROJECTS NEW: #{current_member.managed_company.id} == #{params[:company_id]}"
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      puts "VALIDO PROJECTS NEW"
      return true
    end
    puts "INVALIDO PROJECTS NEW"
    false
  end
  def projects_create_validation params
    return projects_new_validation params
  end
  
  def projects_edit_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    if(params[:company_id] && params[:project_id] && current_member.managed_project.id == params[:project_id].to_i)
      return true
    end
    false
  end
  def projects_update_validation params
    projects_edit_validation params
  end
  
  def projects_show_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    project = current_member.projects.where(["id = ?", params[:project_id]]).first
    if(params[:company_id] && params[:project_id] && project)
      return true
    end
    false
  end
  
  def projects_index_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    company = current_member.companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    false
  end
  ##################################################
  
  
  ##
  # User
  ##
  def users_new_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    false
  end
  def users_create_validation params
    return projects_new_validation params
  end
  
  def users_edit_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    if(params[:user_id] && current_member.id == params[:user_id].to_i)
      return true
    end
    false
  end
  def users_update_validation params
    users_edit_validation params
  end
  
  def users_show_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    project = current_member.projects.where(["id = ?", params[:project_id]]).first
    if(params[:company_id] && params[:project_id] && project)
      return true
    end
    false
  end
  
  def users_index_validation params
    company = current_member.managed_companies.where(["id = ?", params[:company_id]]).first
    if(params[:company_id] && company)
      return true
    end
    if(params[:company_id] && params[:project_id] && current_member.managed_project.id == params[:project_id].to_i)
      return true
    end
    false
  end
  ##################################################
  
  
  ##
  # Timecard
  ##
  def timecards_new_validation params
    project = current_member.projects.where(["id = ?", params[:project_id]]).first
    if(params[:project_id] && project)
      return true
    end
    false
  end
  def timecards_create_validation params
    return timecards_new_validation params
  end
  
  def timecards_edit_validation params
    project = current_member.projects.where(["id = ?", params[:project_id]]).first
    timecard = current_member.timecards.where(["id = ?", params[:timecard_id]]).first
    if(params[:project_id] && project && params[:timecard_id] && timecards)
      return true
    end
    project = current_member.managed_projects.where(["id = ?", params[:project_id]]).first
    timecard = project? project.timecards.where(["id = ?", params[:timecard_id]]).first : nil
    if(params[:project_id] && project && params[:timecard_id] && timecards)
      return true
    end
    false
  end
  def timecards_update_validation params
    timecards_edit_validation params
  end
  
  def timecards_show_validation params
    #Owner
    project = current_member.projects.where(["id = ?", params[:project_id]]).first
    timecard = current_member.timecards.where(["id = ?", params[:timecard_id]]).first
    if(params[:project_id] && project && params[:timecard_id] && timecards)
      return true
    end
    #Company Manager
    timecard = project? project.timecards.where(["id = ?", params[:timecard_id]]).first : nil
    company = current_member.managed_companies.where(["id = ?", params[:project_id]]).first : nil
    if(company && timecard)
      return true
    end
    #Project Manager
    project = current_member.managed_projects.where(["id = ?", params[:project_id]]).first
    if(params[:project_id] && project && params[:timecard_id] && timecards)
      return true
    end
    false
  end
  
  def timecards_index_validation params
    timecards_show_validation params
  end
  ##################################################
    
end