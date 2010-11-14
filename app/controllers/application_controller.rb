class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Includes Security
  include SecurityManager
  
  rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token
  
  helper :all # include all helpers, all the time
  helper_method :current_member
  helper_method :remove_whitespaces, :redo_whitespaces
  helper_method :timecards_status_name

  before_filter :require_no_member, :only=> [:login, :login_submit, :register, :register_create]
  before_filter :require_member, :except=> [:logout]
  before_filter :validate_access, :except => [:login, :login_submit, :register, :register_create]
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def validate_access
    #require_member
    puts "VALIDATE ACCESS:#{controller_name}, #{action_name}"

    if(current_member)
      if (current_member.password_changed_at || (controller_name == "users" && (action_name == "edit_self" || action_name == "update_self")))
        unless (has_permission?(controller_name, action_name, params))
          flash[:access_msg] = "You are not authorized to access this page."
          session[:redirect_url] = request.fullpath
          if request.xhr?
            render :json => "{\"success\":false, \"message\":\"You are not authorized to access this page.\"}"
          else
            redirect_to login_url # TODO REDIRECCIONAR A NO TIENE PERMISOS
          end
        end
      else
        flash[:access_msg] = "It seems to be your first login, please change your temporal password."
        redirect_to edit_self_path
      end
    else
      flash[:access_msg] = "You are not authorized to access this page, please login first."
      if request.xhr?
        render :json => "{\"redirect\":true, \"url\": \"#{login_url}\"}"
      else
        redirect_to login_url
      end
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:redirect_url] || default)
    session[:redirect_url] = nil
  end
  
  def timecards_status_name status
    case status
    when PROCESS
      "Process"
    when REVISION
      "Revision"
    when REJECT
      "Rejected"
    when ACCEPT
      "Accepted"
    when FINISHED
      "Finished"
    else
      "New Timecard"
    end
  end

  ###################### MEMBER ##########################
  def current_member_session
    return @current_member_session if defined?(@current_admin_session)
    @current_member_session = UserSession.find()
  end

  def current_member
    return @current_member if defined?(@current_member)
    @current_member = current_member_session && current_member_session.record
  end

  def require_member
    unless current_member
      if request.xhr?
        # An unauthorize response
        render :status => 401, :json => "{'errormsg':\"You are not authorized to access this page, please login first.\", 'redirect_page':'#{admin_login_url}'}"
      else
        redirect_to login_url
      end
      return false
    end
  end

  def require_no_member
    if current_member
      if request.xhr?
        # An unauthorize response
        render :status => 401, :json => "{'errormsg':\"This page is for not logged in users, please logout first.\", 'redirect_page':'#{admin_control_panels_url}'}"
      else
        redirect_to root_url
      end
      return false
    end
  end
  
  def bad_token
    # flash[:notice] = "That session has expired. Please log in again."
    # a bad request response
    if request.xhr?
      # An unauthorize response
      render :status => 500, :json => "{'success':false,'errormsg':\"Your session has expired, please login again.\", 'redirect_page':'#{admin_login_url}'}"
    else
      flash[:notice] = "That session has expired. Please log in again."
      redirect_to login_url
    end
    #redirect_to :back
  end
  
  # General rescue for HTTP Error
  # 
  def rescue_HTTPError(e)
    logger.error("HTTP ERROR --- #{e}")
    #This Text should be change for an 500 error.
    render :file => "public/500.html", :status => 500
  end

  def valid_xhr_request?
    if !request.xhr?
       render :file => "public/404.html", :status => 404
       return
    end
  end
  
  def remove_whitespaces(phrase)
    phrase.gsub(/\s+/,'_')
  end
  
  def redo_whitespaces(phrase)
    phrase.gsub('_', ' ')
  end
  
  # Method that looks for the first error within the defined object 
  def first_error(object)
    return_value = ""
    if(object.is_a?(Array))
      object.each {|obj| obj.errors.each{|attr, value| return value }}
    else
      object.errors.each{|attr,value| return value }
    end
    return_value
  end  
end
