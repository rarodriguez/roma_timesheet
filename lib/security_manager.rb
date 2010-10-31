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
  
  def f params
    params
    binding
  end

  
  ## Specific extra validation methods ##
  def projects_new_validation params
    puts "PROJECTS NEW: #{current_member.managed_company.id} == #{params[:company_id]}"
    if(params[:company_id] && current_member.managed_company.id == params[:company_id].to_i)
      puts "VALIDO PROJECTS NEW"
      return true
    end
    puts "INVALIDO PROJECTS NEW"
    false
  end
  
  def projects_create_validation params
    return projects_new_validation params
  end
  
end