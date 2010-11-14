# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

COMPANY=0
PROJECT=1
EMPLOYEE=2

roles = Role.create([
                {:name => 'company_manager', :description =>''},
                {:name => 'project_manager', :description =>''},
                {:name => 'employee', :description =>''}
              ])

permissions = Permission.create([
                {:name => 'contents_dashboard', :roles =>[roles[EMPLOYEE]], :needs_extra_validation => 0},
  
                {:name => 'companies_edit', :roles =>[roles[COMPANY]]},
                {:name => 'companies_update', :roles =>[roles[COMPANY]]},
                {:name => 'companies_destroy', :roles =>[roles[COMPANY]]},
                {:name => 'companies_show', :roles =>[roles[EMPLOYEE]]},
                  
                
                {:name => 'projects_new', :roles =>[roles[COMPANY]]},
                {:name => 'projects_create', :roles =>[roles[COMPANY]]},
                {:name => 'projects_destroy', :roles =>[roles[COMPANY]]},
                {:name => 'projects_edit', :roles =>[roles[COMPANY],roles[PROJECT]]},
                {:name => 'projects_update', :roles =>[roles[COMPANY],roles[PROJECT]]},
                {:name => 'projects_show', :roles =>[roles[EMPLOYEE]]},
                {:name => 'projects_index', :roles =>[roles[EMPLOYEE]]},
                
                  
                {:name => 'users_new', :roles =>[roles[COMPANY]]},
                {:name => 'users_create', :roles =>[roles[COMPANY]]},
                {:name => 'users_edit', :roles =>[roles[EMPLOYEE]]},
                {:name => 'users_edit_self', :roles =>[roles[EMPLOYEE]], :needs_extra_validation => 0},
                {:name => 'users_update', :roles =>[roles[EMPLOYEE]]},
                {:name => 'users_update_self', :roles =>[roles[EMPLOYEE]], :needs_extra_validation => 0},
                {:name => 'users_destroy', :roles =>[roles[EMPLOYEE]]},
                {:name => 'users_show', :roles =>[roles[EMPLOYEE]]},   
                {:name => 'users_index', :roles =>[roles[EMPLOYEE]]}, 
                  
                  
                {:name => 'timecards_add_hours', :roles =>[roles[EMPLOYEE]]}, 
                {:name => 'timecards_create', :roles =>[roles[EMPLOYEE]]},   
                {:name => 'timecards_edit', :roles =>[roles[EMPLOYEE]]}, 
                #{:name => 'timecards_update', :roles =>[roles[EMPLOYEE]]}, 
                #{:name => 'timecards_destroy'},   
                {:name => 'timecards_change_state', :roles =>[roles[EMPLOYEE]], :needs_extra_validation => 0},  
                {:name => 'timecards_process', :roles =>[roles[EMPLOYEE]]},   
                {:name => 'timecards_revision', :roles =>[roles[EMPLOYEE]]},   
                {:name => 'timecards_reject', :roles =>[roles[COMPANY],roles[PROJECT]]},   
                {:name => 'timecards_accept', :roles =>[roles[COMPANY],roles[PROJECT]]}, 
                {:name => 'timecards_finished', :roles =>[roles[COMPANY],roles[PROJECT]]}, 
                {:name => 'timecards_show', :roles =>[roles[EMPLOYEE]]},
                {:name => 'timecards_index', :roles =>[roles[EMPLOYEE]]}, 
                  
                  
                {:name => 'hours_create', :roles =>[roles[EMPLOYEE]]}, 
                {:name => 'hours_destroy', :roles =>[roles[EMPLOYEE]]},
                {:name => 'hours_index', :roles =>[roles[EMPLOYEE]]}
              ])
  
