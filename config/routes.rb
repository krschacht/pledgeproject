Pledgeproject::Application.routes.draw do |map|

  scope 'projects/:project_id' do
    resources :pledges, :name_prefix => 'project' do
      member do
        get :done
      end
    end
  end
  
  match 'projects/:project_id/pledges/new_embed(.:format)'  => 'pledges#new_embed', :as => 'new_embed_project_pledge'

  # resource :pledges
  # match 'projects/:project_id/pledges/new(.:format)'        => 'pledges#new',       :as => 'new_project_pledge'
  
  # match 'pledges/done/(:id)'                                => 'pledges#done',      :as => 'pledge_done'


  resource :user_session
  
  match 'admin'                                   => 'admin#index',                 :as => 'admin'
#  match 'admin/projects/:project_id/pledge_embed' => 'admin/projects#pledge_embed', :as => 'admin_project_pledge_embed'
#  match 'admin/pledges/for_project/:id(.:format)' => 'admin/pledges#for_project',   :as => 'admin_pledges_for_project'
  
  namespace :admin do
    resources :projects do
      resources :pledges
      
      member do
        get :pledge_embed
      end
    end
    resources :users
  end
  
  resource  :account,  :controller => "users"
  resources :users, :except => [ :index ]
  
  match 'users/:id/projects/widget(.:format)', :to => 'projects#widget', :as => "user_projects_widget"















  
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
