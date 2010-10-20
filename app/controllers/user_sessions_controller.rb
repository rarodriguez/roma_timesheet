class UserSessionsController < ApplicationController
  before_filter :require_no_member, :only=>[:member_login, :member_login_submit]
  before_filter :require_member, :only=>[:member_logout]
  # filter to prepare the model for creating an admin session
  before_filter :prepare_member_model, :only => [:member_login, :member_login_submit]
  filter_parameter_logging 'password'
  
   # Backend login page
  def login
    @member_session = UserSession.new(params[:user_session])
  end
  
    # Backend login action 
  def login_submit
    #@user_session = UserSession.new(params[:user])
    if(@member_session.save)
      @current_member = @member_session.record
      #Reward.update_user_reward(@member_session.record)
      #updates users' specific messages
      session[:from_login] = 1
      update_messages_information(@current_member)
      
      member = Member.find_by_user_id(@current_member.id)
      session[:member_name] = (member.first_name.nil? ? @current_member.login : member.first_name)  
      render :json => "{\"success\":true}"
    else
      render :json => "{\"success\":false,\"errormsg\":\"Oops, The email or password you entered is incorrect.\"}"
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
    #UserSession.with_scope(:find_options => {:conditions => "role_id = 1 && status != 0"}) do
    params[:user_session][:remember_me] = !params[:user_session][:remember_me].nil?
    @member_session = UserSession.new(params[:user_session])
  end
  
end