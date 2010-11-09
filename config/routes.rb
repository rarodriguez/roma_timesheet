Timesheet::Application.routes.draw do
  root :to => "user_sessions#login"
  
  #resources :hours

  resources :roles

  resources :permissions

  #resources :projects

  #resources :companies
  
  resources :companies, :constraints => {:id => /[0-9]+/, :company_id =>/[0-9]+/}   do
    resources :projects, :constraints => {:id => /[0-9]+/}
    resources :users, :constraints => {:id => /[0-9]+/}
  end
  
  match 'login' => 'user_sessions#login', :as => :login, :via => "get"
  match 'login' => 'user_sessions#login_submit', :as => :login_create, :via => "post"
  
  match 'register' => 'users#register', :as => :register, :via => "get"
  match 'register' => 'users#register_create', :as => :register_create, :via => "post"
  
  match 'dashboard' => 'contents#dashboard', :as => :dashboard, :via => "get"
  
  match 'edit_self' => 'users#edit_self', :as => :edit_self, :via => "get"
  match 'edit_self' => 'users#update_self', :as => :update_self, :via => "post"
  
  #resources :timecards
  
  match 'projects/:project_id/timecards' => 'timecards#index', :as=>:timecards, :via=>'get'
  match 'projects/:project_id/timecards/new' => 'timecards#new', :as=>:new_timecard, :via=>'get'
  match 'projects/:project_id/timecards' => 'timecards#create', :as=>:timecards, :via=>'post'
  match 'projects/:project_id/timecards/:id/edit' => 'timecards#edit', :as=>:edit_timecard, :via=>'get'
  match 'projects/:project_id/timecards/:id' => 'timecards#update', :as=>:edit_timecard, :via=>'put'
  match 'projects/:project_id/timecards/:id' => 'timecards#show', :as=>:new_timecard, :via=>'get'
  match 'projects/:project_id/timecards/:id' => 'timecards#destroy', :as=>:new_timecard, :via=>'delete'
  
  match 'timecards/:timecard_id/hours' => 'hours#create', :as=>:create_hours, :via=>'post'
  match 'timecards/:timecard_id/hours/list' => 'hours#index', :as=>:list_hours, :via=>'post'
  match 'timecards/:timecard_id/hours/:id' => 'hours#destroy', :as=>:create_hours, :via=>'delete'
  
  #match 'timecards/:timecard_id/hours/add' => 'hours#create', :as=>:create_hours, :via=>'post'
#  match 'my_companies' => 'companies#my_companies', :as => :my_companies, :via => "post"
#  match 'my_timecards' => 'timecards#my_timecards', :as => :my_timecards, :via => "post"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
