Pledgeproject::Application.routes.draw do |map|

  match 'url/:id'  => 'tiny_url#index'
  
  ## Admin routes
  
  match 'admin'         => 'admin/projects#index', :as => 'admin'
  match 'admin/setup'   => 'admin#setup', :as => 'admin_setup'
  match 'admin/su/:id'  => 'admin#su',    :as => 'admin_su'
  match 'admin/unsu'    => 'admin#unsu',  :as => 'admin_unsu'
  
  namespace :admin do
    resources :projects do
      resources :pledges do
        member do
          put :invoice_custom
          get :confirm_invoice
        end
      end
      
      member do
        get :pledge_embed
        put :invoice_custom
        get :confirm_invoice
      end
    end
    
    resources :users
    resources :groups do
      member do
        get :vote_embed
      end
    end
    resources :votes
  end
  
  ## Public routes

  resource :user_session  
  resource :account,  :controller => "users"
  resources :users, :except => [ :index ]  

  # I don't know how to do this inside the scope :(
  match 'groups/:group_id/votes/new_embed(.:format)' => 'votes#new_embed', 
        :as => 'new_embed_group_vote'

  scope 'groups/:group_id' do
    resources :votes, :only => [ :new, :create ], :name_prefix => 'group' do
      member do
        get :done
      end
    end
  end

  # I don't know how to do this inside the scope :(  
  match 'projects/:project_id/pledges/new_embed(.:format)' => 'pledges#new_embed', 
        :as => 'new_embed_project_pledge'

  scope 'projects/:project_id' do
    resources :pledges, :only => [ :new, :create ], :name_prefix => 'project' do
      member do
        get :done
      end
    end    
  end
    
  match 'users/:id/projects/widget(.:format)', :to => 'projects#widget', :as => "user_projects_widget"

  post "paypal/postback"



  
  # match "/login" => 'user_sessions#new'
  match "/logout" => 'user_sessions#destroy'  
  
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
