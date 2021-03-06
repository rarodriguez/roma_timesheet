class UserSessionsController < ApplicationController
  # filter to prepare the model for creating an admin session
  before_filter :prepare_member_model, :only => [:login, :login_submit]
  
  # Login page
  def login
      puts "LOGIN #{controller_name}, #{action_name}"
      if(current_member)
        redirect_to dashboard_url
      end
  end
  
  # Backend login action 
  def login_submit
    #@user_session = UserSession.new(params[:user])
    if(@member_session.save)
      puts "LOGIN_SUBMIT #{controller_name}, #{action_name}"
      @current_member = @member_session.record
      puts @current_member
      session[:member_name] = (@current_member.name.nil? ? @current_member.login : @current_member.name)
      redirect_back_or_default dashboard_path
    else
      puts "LOGIN_SUBMIT ELSE #{controller_name}, #{action_name}"
      render :action => "login"
    end
  end
  
  def logout
    current_member_session.destroy
    session.clear
    redirect_to login_url
  end
  
  private

  def prepare_member_model
    params[:user_session] ||= {}
    params[:user_session][:remember_me] = !params[:user_session][:remember_me].nil?
    @member_session = UserSession.new(params[:user_session])
  end
  
end