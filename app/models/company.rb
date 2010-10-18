class Company < ActiveRecord::Base
  belongs_to :manager, :class_name => 'user'
  has_many :projects
  has_and_belongs_to_many :users
end
