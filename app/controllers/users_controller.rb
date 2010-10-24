class UsersController < ApplicationController
 
  # GET /users
  # GET /users.xml
  def index
    #@current_action = action_name
    #@current_controller =  controller_name
    
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
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

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
