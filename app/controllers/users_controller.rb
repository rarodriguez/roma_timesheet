class UsersController < ApplicationController
 
  # GET /users
  # GET /users.xml
  def index
    #@current_action = action_name
    #@current_controller =  controller_name
    
    @company = Company.find(params[:company_id])
    @users = @company.users
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /register
  def register
    @user = User.new
    @company = Company.new
  end
  
  # POST /register
  def register_create
    @user = User.new(params[:user])
    # TODO add the method to asign the ROLE
    # @user.roles << Role.find_by_name(Admin)
    @company = Company.new(params[:company])
    
    if [@user.valid?, @company.valid?].all? 
      begin
        User.transaction do
          @user.save!
          @company.manager = @user
          @company.save!
          # Adds the user to the list of users that belongs to the company
          @company.users << @user
        end
        redirect_to "/"
      rescue Exception => e
        logger.error e.message
        logger.error e.backtrace
        render :action=>'register'
      end
    else
      @user.password = ""
      @user.password_confirmation = ""
      render :action => "register"
    end
  end


  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @company = Company.find(params[:company_id])
    if @user.save
      @company.users << @user
      redirect_to(company_user(:company_id=>@company.id, :id=>@user.id), :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(company_user(:company_id=>@company.id, :id=>@user.id), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end
end
