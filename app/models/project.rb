class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :manager, :class_name => "User"
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'  
  belongs_to :company
end
