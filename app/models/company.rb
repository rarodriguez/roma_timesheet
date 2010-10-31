class Company < ActiveRecord::Base
  belongs_to :manager, :class_name => "User", :foreign_key => 'user_id'
  has_many :projects
  has_and_belongs_to_many :users
  has_many :timecards, :through => :projects
  
  validates_presence_of :name, :message=>"Oops, you can't proceed until you enter your company's name."
  validates_presence_of :description, :message=>"Oops, you can't proceed until you enter your company's description."
  
  validates_length_of :name, :maximum => 100, :message=>"Oops, your company's name is too long. The maximum length is 100 characters."
  validates_length_of :address, :maximum=>200, :message=>"Oops, your company's address is too long. The maximum length is 200 characters."
  validates_length_of :description, :maximum=>10000, :message=>"Oops, your company the description for your company is too long. The maximum length is 10000 characters."
  
  def self.user_companies(user)
    # We should only allow access if the user is the owner of the company
    # companies = user.companies
    companies = self.all
    companies_param = []
    companies.each do |comp|
      comp_hash = {}
      comp_hash[:id] = comp.id
      comp_hash[:name] = comp.name
      comp_hash[:total_projects] = comp.projects.count
      total_hours = 0
      comp.timecards.each{|tc| total_hours += tc.total_hours}
      comp_hash[:total_hours] = total_hours && total_hours != '' ? total_hours : 0
      comp_hash[:total_employees] = comp.users.count
      comp_hash[:details] = "Details"
      companies_param << comp_hash
    end
    companies_param.to_local_jqgrid_hash([:id,:name,:total_projects,:total_employees,:total_hours,:details])
  end
end
