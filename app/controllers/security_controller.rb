class SecurityController < ApplicationController
  
  #Method of before_filter
  def validate_access_sec (controller, action)
    if (current_member && current_member.password_changed_at)
      has_permission?(controller, action)
    end
    redirect_to :login
  end
  
  # Generic method to validate the actions of the user in the controller
  def has_permission? (controller, action)
    if (controller && action)
      action = "#{controller}_#{action}"
      action.gsub!(/\W+/, "")
      roles = current_member.roles
      roles.each do |role|
        permission = role.permissions.where(["name = ?", action]).first
        
        if (permission && permission.name == action)
          if (permission.needs_extra_validation)
            return eval("#{action}_validation")
          end
          return true
        end
        
      end
    end
    false  
  end  
  
  ## Specific extra validation methods ##
  
  
end