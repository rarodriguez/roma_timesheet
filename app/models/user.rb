class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :roles
  has_one :managed_project, :class_name => 'project'
  has_one :managed_company, :class_name => 'company'
  has_many :timecards
end
