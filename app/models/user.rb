class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :roles
  has_one :managed_project, :class_name => 'project'
  has_one :managed_company, :class_name => 'company'
  has_many :timecards
  
  # primary username validation
  validates_presence_of :login, :message=>"Oops, you can't proceed until you enter your email address."
  validates_uniqueness_of :login, :scope=>:role_id, :message=>"Oops, the email address you entered is already associated with an envaulted account."
  validates_format_of :login,
                      :with => /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      :message => "Oops, you can't proceed until you enter a valid email address."
                      
  validates_presence_of :password, :if=>Proc.new{|u|u.ignore_password != 1}, :message=>"Oops, you can't proceed until you enter a password."
  
  validate :format_of_password, :if=>Proc.new{|u|u.ignore_password != 1}
  validates_confirmation_of :password, :message=>"Oops, you can't proceed until the password and password confirmation match.", :if=>Proc.new{|u|u.ignore_password != 1}
  
  attr_accessor :ignore_password
  attr_accessor :check_old_pass
  
  attr_accessor :old_pass
  attr_accessor :old_crypted_password
  attr_accessor :old_password_salt
  
  validate :change_password_valid_info?, :on=>:update
  
  acts_as_authentic do |c|  
    #c.session_ids = [:member]
    c.validate_login_field = false
    c.validate_password_field = false
    c.logged_in_timeout = 10.minutes
    c.ignore_blank_passwords = false
  end
  
  # Method that allows the user to login, this verification always is taken in consideration before login.
  def active?
    self.status_id == 1 || self.status_id == 2 
  end
  
  def format_of_password
    if(!self.password.match(/^((?=.{8,17}$)(?=.*[a-z])(?=.*\d)(?=.*[A-Z])(?=.*[\!\@\#\$\%\&\*\-\+])).*/))
      self.errors.add(:password,"Your password must contain between 8 and 17 characters. Also it should have at least a letter in lowercase, a letter in UPPERCASE, a number and a valid special character: '!@\#$%&*-+'.")
    end
  end
  
  # Check if the user must change his/her password.
  def password_expired?
    pass_expiration = Asset.find_by_name("password_expiration").data.to_i
    self.last_password_change_at + pass_expiration.days < Date.today
  end
  
  private
  def change_password_valid_info?
    if(!self.check_old_pass.nil?)
      old = self.old_pass
      new = self.password
      if(!Authlogic::CryptoProviders::Sha512.matches?(self.old_crypted_password, self.old_pass + self.old_password_salt))
        self.errors.add(:password, "You typed a wrong old password.")
      elsif(Authlogic::CryptoProviders::Sha512.matches?(self.old_crypted_password, self.password + self.old_password_salt))
        self.errors.add(:password, "Cannot be the same than the old password.")
      end
    end
  end
end
