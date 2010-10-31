class UserSessionsController < ApplicationController
  before_filter :require_no_member, :only=>[:member_login, :member_login_submit]
  before_filter :require_member, :only=>[:member_logout]
  # filter to prepare the model for creating an admin session
  before_filter :prepare_member_model, :only => [:login, :login_submit]
  filter_parameter_logging 'password'
  
   # Backend login page
  def login
  end
  
    # Backend login action 
  def login_submit
    #@user_session = UserSession.new(params[:user])
    if(@member_session.save)
      @current_member = @member_session.record
      session[:member_name] = (@current_member.name.nil? ? @current_member.login : @current_member.name)
      redirect_to dashboard_path
    else
      render :action => "login"
    end
  end
  
  def member_logout
    current_member_session.destroy
    session.clear
    redirect_to root_url
  end
  
  private

  def prepare_member_model
    params[:user_session] ||= {}
    params[:user_session][:remember_me] = !params[:user_session][:remember_me].nil?
    @member_session = UserSession.new(params[:user_session])
  end
  
end