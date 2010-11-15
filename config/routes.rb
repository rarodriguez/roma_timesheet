Timesheet::Application.routes.draw do 
  root :to => "user_sessions#login"
  
  resources :companies, :constraints => {:id => /[0-9]+/, :company_id =>/[0-9]+/}   do
    resources :projects, :constraints => {:id => /[0-9]+/}
    resources :users, :constraints => {:id => /[0-9]+/}
  end
  
  match 'login' => 'user_sessions#login', :as => :login, :via => "get"
  match 'login' => 'user_sessions#login_submit', :as => :login_create, :via => "post"
  match 'logout' => 'user_sessions#logout', :as => :logout, :via => "delete"
  
  match 'register' => 'users#register', :as => :register, :via => "get"
  match 'register' => 'users#register_create', :as => :register_create, :via => "post"
  
  match 'dashboard' => 'contents#dashboard', :as => :dashboard, :via => "get"
  
  match 'edit_self' => 'users#edit_self', :as => :edit_self, :via => "get"
  match 'edit_self' => 'users#update_self', :as => :update_self, :via => "put"
  
  match 'projects/:project_id/timecards' => 'timecards#index', :as=>:timecards, :via=>'get', :constraints => {:project_id => /[0-9]+/}
  match 'projects/:project_id/timecards/new' => 'timecards#new', :as=>:new_timecard, :via=>'get', :constraints => {:project_id => /[0-9]+/}
  match 'projects/:project_id/timecards' => 'timecards#create', :as=>:timecards, :via=>'post', :constraints => {:project_id => /[0-9]+/}
  match 'projects/:project_id/timecards/:id/edit' => 'timecards#edit', :as=>:edit_timecard, :via=>'get', :constraints => {:project_id => /[0-9]+/, :id => /[0-9]+/}
  match 'projects/:project_id/timecards/:id' => 'timecards#update', :as=>:update_timecard, :via=>'put', :constraints => {:project_id => /[0-9]+/, :id => /[0-9]+/}
  match 'projects/:project_id/timecards/:id' => 'timecards#show', :as=>:timecard, :via=>'get', :constraints => {:project_id => /[0-9]+/, :id => /[0-9]+/}
  match 'projects/:project_id/timecards/:id' => 'timecards#destroy', :as=>:destroy_timecard, :via=>'delete', :constraints => {:project_id => /[0-9]+/, :id => /[0-9]+/}
  
  match 'projects/:project_id/timecards/:id/(:change_to)' => 'timecards#change_state', :as=>:change_state_timecard, :via=>'post', :constraints => {:project_id => /[0-9]+/, :id => /[0-9]+/}
  
  match 'timecards/:timecard_id/hours' => 'hours#create', :as=>:create_hours, :via=>'post', :constraints => {:timecard_id => /[0-9]+/}
  match 'timecards/:timecard_id/hours/list' => 'hours#index', :as=>:list_hours, :via=>'post', :constraints => {:timecard_id => /[0-9]+/}
  match 'timecards/:timecard_id/hours/:id' => 'hours#destroy', :as=>:destroy_hours, :via=>'delete', :constraints => {:timecard_id => /[0-9]+/}
  
end
