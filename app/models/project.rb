class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :manager, :class_name => "User", :foreign_key=>'user_id'
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'  
  belongs_to :company
  
  validates_presence_of :name, :message=>"Oops, you can't proceed until you enter your project's name."
  validates_length_of :name, :maximum => 100, :message=>"Oops, your project's name is too long. The maximum length is 100 characters."
  
  validates_presence_of :manager, :message=>"Oops, you can't proceed until you select a manager for your project."
  validates_presence_of :company, :message=>"Oops, you can't proceed until you select a valid company for your project."
end
