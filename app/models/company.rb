class Company < ActiveRecord::Base
  belongs_to :manager, :class_name => "User"
  has_many :projects
  has_and_belongs_to_many :users
  has_many :timecards, :through => :projects
  
  validates_presence_of :name, :message=>"Oops, you can't proceed until you enter your company's name."
  validates_presence_of :description, :message=>"Oops, you can't proceed until you enter your company's description."
  
  validates_length_of :name, :maximum => 100, :message=>"Oops, your company's name is too long. The maximum length is 100 characters."
  validates_length_of :address, :maximum=>200, :message=>"Oops, your company's address is too long. The maximum length is 200 characters."
  validates_length_of :description, :maximum=>10000, :message=>"Oops, your company the description for your company is too long. The maximum length is 10000 characters."
  
end
