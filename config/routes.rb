DemoComentarios::Application.routes.draw do

  resources :twitter_data

  get "twitter_data/:idc/:opcion" => "twitter_data#index"
  get "twitter_data/new/:idc/:opcion" => "twitter_data#new"
  get "twitter_data/:id/edit/:idc" => "twitter_data#edit"

  get "users/new/:option" => "users#new", :as => "new_user"

  resources :info_social_networks

  resources :social_networks

  post "social_networks/add_image" => "social_networks#add_image"

  resources :facebook_data

  get "facebook_data/callback/:idc/:start_date/:end_date" => "facebook_data#callback"
  get "facebook_data/callback/:idc" => "facebook#callback"
  get "facebook_data/:idc/:opcion" => "facebook_data#index"
  get "facebook_data/new/:idc/:opcion" => "facebook_data#new"
  get "facebook_data/:id/edit/:idc" => "facebook_data#edit"
  post "facebook_data/save_comment" => "facebook_data#save_comment"

  get 'clients/social_networks/:idc' => 'clients#social_networks'
  get 'clients/facebook' => 'clients#facebook', :as => "client_facebook"
  post 'clients/insert_social_network' => 'clients#insert_social_network'

  #match 'clients/social_networks', :controller => 'clients', :action => 'social_networks', :conditions => { :method => :get }
  resources :clients


  get "validate_user/" => "home#validate_user"
  root :to => "home#index"
  
  devise_for :users

  get 'users/delete'
  put 'users/destroy'
  post 'users/create'

  resources :users, :only => :show
  
  resources :revisions

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
