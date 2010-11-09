# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

permissions = Permission.create([
                {:name => 'contents_dashboard', :needs_extra_validation => 0},
  
                {:name => 'companies_edit'},
                {:name => 'companies_update'},
                {:name => 'companies_destroy'},
                {:name => 'companies_show'},
                  
                
                {:name => 'projects_new'},
                {:name => 'projects_create'},
                {:name => 'projects_destroy'},
                {:name => 'projects_edit'},
                {:name => 'projects_update'},
                {:name => 'projects_show'},
                {:name => 'projects_index'},
                
                  
                {:name => 'users_new'},
                {:name => 'users_create'},
                {:name => 'users_edit'},
                {:name => 'users_update'},
                {:name => 'users_destroy'},
                {:name => 'users_show'},   
                {:name => 'users_index'}, 
                  
                  
                {:name => 'timecards_new'}, 
                {:name => 'timecards_create'},   
                {:name => 'timecards_edit'}, 
                {:name => 'timecards_update'}, 
                {:name => 'timecards_destroy'},   
                {:name => 'timecards_process'},   
                {:name => 'timecards_revision'},   
                {:name => 'timecards_reject'},   
                {:name => 'timecards_accept'}, 
                {:name => 'timecards_finished'}, 
                {:name => 'timecards_show'}, 
                  
                  
                {:name => 'hours_create'}, 
                {:name => 'hours_destroy'},
                {:name => 'hours_index'}
              ])
              
  roles = Role.create([
                {:name => 'company_manager', :description =>''},
                {:name => 'project_manager', :description =>''},
                {:name => 'employee', :description =>''}
              ])
  
