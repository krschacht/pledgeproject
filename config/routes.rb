Pledgeproject::Application.routes.draw do |map|
  match 'projects/widget(.:format)', :to => 'projects#widget', :as => "projects_widget"

  resource :pledges
  resource :user_session

  match 'projects/:project_id/pledges/new(.:format)'        => 'pledges#new',       :as => 'new_project_pledge'
  match 'projects/:project_id/pledges/new_embed(.:format)'  => 'pledges#new_embed', :as => 'new_project_pledge_embed'
  match 'pledges/done/(:id)'                                => 'pledges#done',      :as => 'pledge_done'
  
  match 'admin'                                   => 'admin#index',                 :as => 'admin'
  match 'admin/login'                             => 'admin#login',                 :as => 'admin_login'
  match 'admin/logout'                            => 'admin#logout',                :as => 'admin_logout'
  match 'admin/projects/:project_id/pledge_embed' => 'admin/projects#pledge_embed', :as => 'admin_project_pledge_embed'
  match 'admin/pledges/for_project/:id(.:format)' => 'admin/pledges#for_project',   :as => 'admin_pledges_for_project'
  
  namespace :admin do    
    resources :pledges
    resources :projects
    resources :users
  end
  
  resource  :account,  :controller => "users"
  resources :users
  
  # match "/login" => 'user_sessions#new'
  # match "/logout" => 'user_sessions#destroy'  
  
#  resources :pledges
  
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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
