class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_admin
  helper_method :remove_whitespaces, :redo_whitespaces

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected

  def redirect_back_or_default(default)
    redirect_to(session[:redirect_url] || default)
    session[:redirect_url] = nil
  end

  ###################### MEMBER ##########################
  def current_member_session
    return @current_member_session if defined?(@current_admin_session)
    @current_member_session = UserSession.find(:admin)
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

  def rescue_SOAPFault(e)
    logger.error("SOAP ERROR --- #{e}")
    render :file => "public/500.html", :status => 500
  end

  def valid_xhr_request?
    if !request.xhr?
       render :file => "public/404.html", :status => 404
    end
  end
  
  def remove_whitespaces(phrase)
    phrase.gsub(/\s+/,'_')
  end
  
  def redo_whitespaces(phrase)
    phrase.gsub('_', ' ')
  end  
end
