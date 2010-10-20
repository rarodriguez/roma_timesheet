class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  
#  validate :password_expired?, :on => :create
#    
  def password_expired?
    self.attempted_record.password_expired?
  end
  
  validate :generic_error, :on=>:create
  
  def generic_error
    if((@login == nil && @password != nil) || (@login != nil && @password == nil))
      errors.clear
      errors.add_to_base("You did not provide enough details for authentication.")
    elsif errors.count > 0
      errors.clear
      errors.add_to_base("Sorry, we couldn't find that account and password combination.")
    end
  end
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  
end