DemoComentarios::Application.routes.draw do


  scope ':locale' do

    resources :pinterest_data
    post "pinterest_data" => "pinterest_data#create", :as => "pinterest_create" 
    get "pinterest_data/:idc/:opcion/:id_social" => "pinterest_data#index", :as => "pinterest_index"
    get "pinterest_data/new/:idc/:opcion/:id_social" => "pinterest_data#new", :as => "pinterest_new"
    get "pinterest_data/:id/edit/:idc/:id_social" => "pinterest_data#edit", :as => "pinterest_edit"
    post "pinterest_data/save_comment" => "pinterest_data#save_comment", :as => "pinterest_save_comment"
    delete "pinterest_data/:id" => "pinterest_data#destroy", :as => "pinterest_delete"
    put "pinterest_data/:id" => "pinterest_data#update", :as => "pinterest_update"

    resource :linkedin_data
    post "linkedin_data" => "linkedin_data#create", :as => "linkedin_datum" 
    get "linkedin_data/:idc/:opcion/:id_social" => "linkedin_data#index", :as => "linkedin_index"
    get "linkedin_data/new/:idc/:opcion/:id_social" => "linkedin_data#new", :as => "linkedin_new"
    get "linkedin_data/:id/edit/:idc/:id_social" => "linkedin_data#edit", :as => "linkedin_edit"
    post "linkedin_data/save_comment" => "linkedin_data#save_comment", :as => "linkedin_save_comment"
    delete "linkedin_data/:id" => "linkedin_data#destroy", :as => "linkedin_delete"
    put "linkedin_data/:id" => "linkedin_data#update", :as => "linkedin_update"

    resources :twitter_data
    get "twitter_data/:idc/:opcion/:id_social" => "twitter_data#index", :as => "twitter_index"
    get "twitter_data/new/:idc/:opcion/:id_social" => "twitter_data#new", :as => "twitter_new"
    get "twitter_data/:id/edit/:idc/:id_social" => "twitter_data#edit", :as => "twitter_edit"
    post "twitter_data/save_comment" => "twitter_data#save_comment", :as => "twitter_save_comment"
    delete "twitter_data/:id" => "twitter_data#destroy", :as => "twitter_delete"

    devise_for :users, :controllers => {:omniauth_callbacks => "auth"}

    resources :facebook_data
    get "facebook_data/callback/:idc/:start_date/:end_date" => "facebook_data#callback", :as => "facebook_callback_dates"
    get "facebook_data/callback/:idc" => "facebook#callback", :as => "facebook_callback"
    get "facebook_data/:idc/:opcion/:id_social" => "facebook_data#index", :as => "facebook_index"
    get "facebook_data/new/:idc/:opcion/:id_social" => "facebook_data#new", :as => "facebook_new"
    get "facebook_data/:id/edit/:idc/:id_social" => "facebook_data#edit", :as => "facebook_edit"
    post "facebook_data/save_comment" => "facebook_data#save_comment", :as => "facebook_save_comment"

    resources :clients
    get 'clients/social_networks/:idc' => 'clients#social_networks', :as => "clients_social_networks"
    get 'clients/facebook' => 'clients#facebook', :as => "client_facebook", :as => "clients_facebook"
    post 'clients/insert_social_network' => 'clients#insert_social_network', :as => "clients_insert_social_network"

    get "users/new/:option" => "users#new", :as => "new_user"
    get 'users/delete' => 'users#delete', :as => "users_delete"
    put 'users/destroy' => 'users#destroy', :as => "users_destroy"
    post 'users/create' => 'users#create', :as => "users_create"

    get "notifications/index" => 'notifications#index', :as => "notifications_index"
    post "notifications/create" => 'notifications#create', :as => "notifications_create"
    get "notifications/reset_password/:token" => "notifications#reset_password", :as => "notifications_reset_password"


    resources :info_social_networks

    resources :social_networks
    get "social_networks/new/:isn" => "social_networks#new", :as => "social_networks_new"
    post "social_networks/add_image" => "social_networks#add_image", :as => "social_networks_add_image"
    post "social_networks/update_comment" => "social_networks#update_comment_image", :as => "social_networks_update_comment"
    delete "social_networks/destroy_image/:id" => "social_networks#destroy_image", :as => "social_networks_destroy_image"
    delete "social_networks/:id" => "social_networks#destroy", :as => "social_networks_delete"

    get "validate_user/" => "home#validate_user", :as => "validate_user"

    resources :revisions

    get "/" => "home#index", :as => "root2"

  end

  root :to => "home#index", :locale => "es"
end
