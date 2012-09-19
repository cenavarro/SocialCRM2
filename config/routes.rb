DemoComentarios::Application.routes.draw do

  get "notifications/index"

  post "notifications/create"

  get "notifications/reset_password/:token" => "notifications#reset_password"

  resources :twitter_data

  get "twitter_data/:idc/:opcion" => "twitter_data#index"
  get "twitter_data/new/:idc/:opcion" => "twitter_data#new"
  get "twitter_data/:id/edit/:idc" => "twitter_data#edit"
  post "twitter_data/save_comment" => "twitter_data#save_comment"

  get "users/new/:option" => "users#new", :as => "new_user"

  resources :info_social_networks

  resources :social_networks

  post "social_networks/add_image" => "social_networks#add_image"
  post "social_networks/update_comment" => "social_networks#update_comment_image"
  delete "social_networks/destroy_image/:id" => "social_networks#destroy_image"

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

  resources :clients

  get "validate_user/" => "home#validate_user"

  root :to => "home#index"

  devise_for :users, :controllers => {:omniauth_callbacks => "auth"}

  get 'users/delete'
  put 'users/destroy'
  post 'users/create'

  resources :users, :only => :show
  resources :revisions
end
