DemoComentarios::Application.routes.draw do



  get "/:locale" => "home#index", :as => "language"

  scope ':locale' do

    resources :google_plus_data, :only => [:create, :destroy, :update]
    post "google_plus_data/save_comment" => "google_plus_data#save_comment", :as => "google_plus_save_comment"
    get "google_plus_data/new/:idc/:opcion/:id_social" => "google_plus_data#new", :as => "google_plus_new"
    get "google_plus_data/:id/edit/:idc/:id_social" => "google_plus_data#edit", :as => "google_plus_edit"
    get "google_plus_data/:idc/:opcion/:id_social" => "google_plus_data#index", :as => "google_plus_index"

    resources :flickr_data, :only => [:create, :destroy, :update]
    post "flickr_data/save_comment" => "flickr_data#save_comment", :as => "flickr_save_comment"
    get "flickr_data/new/:idc/:opcion/:id_social" => "flickr_data#new", :as => "flickr_new"
    get "flickr_data/:id/edit/:idc/:id_social" => "flickr_data#edit", :as => "flickr_edit"
    get "flickr_data/:idc/:opcion/:id_social" => "flickr_data#index", :as => "flickr_index"

    resources :tuenti_data, :only => [:create, :destroy, :update]
    post "tuenti_data/save_comment" => "tuenti_data#save_comment", :as => "tuenti_save_comment"
    get "tuenti_data/new/:idc/:opcion/:id_social" => "tuenti_data#new", :as => "tuenti_new"
    get "tuenti_data/:id/edit/:idc/:id_social" => "tuenti_data#edit", :as => "tuenti_edit"
    get "tuenti_data/:idc/:opcion/:id_social" => "tuenti_data#index", :as => "tuenti_index"

    resources :youtube_data, :only => [:create, :destroy, :update]
    post "youtube_data/save_comment" => "youtube_data#save_comment", :as => "youtube_save_comment"
    get "youtube_data/new/:idc/:opcion/:id_social" => "youtube_data#new", :as => "youtube_new"
    get "youtube_data/:id/edit/:idc/:id_social" => "youtube_data#edit", :as => "youtube_edit"
    get "youtube_data/:idc/:opcion/:id_social" => "youtube_data#index", :as => "youtube_index"

    resources :pinterest_data, :only => [:create, :destroy, :update]
    post "pinterest_data/save_comment" => "pinterest_data#save_comment", :as => "pinterest_save_comment"
    get "pinterest_data/new/:idc/:opcion/:id_social" => "pinterest_data#new", :as => "pinterest_new"
    get "pinterest_data/:id/edit/:idc/:id_social" => "pinterest_data#edit", :as => "pinterest_edit"
    get "pinterest_data/:idc/:opcion/:id_social" => "pinterest_data#index", :as => "pinterest_index"

    resources :linkedin_data, :only => [:create, :destroy, :update]
    post "linkedin_data/save_comment" => "linkedin_data#save_comment", :as => "linkedin_save_comment"
    get "linkedin_data/new/:idc/:opcion/:id_social" => "linkedin_data#new", :as => "linkedin_new"
    get "linkedin_data/:id/edit/:idc/:id_social" => "linkedin_data#edit", :as => "linkedin_edit"
    get "linkedin_data/:idc/:opcion/:id_social" => "linkedin_data#index", :as => "linkedin_index"

    resources :twitter_data, :only => [:create, :destroy, :update]
    post "twitter_data/save_comment" => "twitter_data#save_comment", :as => "twitter_save_comment"
    get "twitter_data/new/:idc/:opcion/:id_social" => "twitter_data#new", :as => "twitter_new"
    get "twitter_data/:id/edit/:idc/:id_social" => "twitter_data#edit", :as => "twitter_edit"
    get "twitter_data/:idc/:opcion/:id_social" => "twitter_data#index", :as => "twitter_index"

    devise_for :users, :controllers => {:omniauth_callbacks => "auth"}

    resources :facebook_data, :only => [:create, :destroy, :update]
    get "facebook_data/callback/:idc/:start_date/:end_date" => "facebook_data#callback", :as => "facebook_callback_dates"
    get "facebook_data/callback/:idc" => "facebook#callback", :as => "facebook_callback"
    post "facebook_data/save_comment" => "facebook_data#save_comment", :as => "facebook_save_comment"
    get "facebook_data/new/:idc/:opcion/:id_social" => "facebook_data#new", :as => "facebook_new"
    get "facebook_data/:id/edit/:idc/:id_social" => "facebook_data#edit", :as => "facebook_edit"
    get "facebook_data/:idc/:opcion/:id_social" => "facebook_data#index", :as => "facebook_index"

    resources :clients, :except => [:show]
    get 'clients/social_networks/:idc' => 'clients#social_networks', :as => "clients_social_networks"
    get 'clients/facebook' => 'clients#facebook', :as => "client_facebook"
    post 'clients/insert_social_network' => 'clients#insert_social_network', :as => "clients_insert_social_network"

    get "users/new/:option" => "users#new", :as => "new_user"
    get 'users/delete' => 'users#delete', :as => "users_delete"
    put 'users/destroy' => 'users#destroy', :as => "users_destroy"
    post 'users/create' => 'users#create', :as => "users_create"

    get "notifications/index" => 'notifications#index', :as => "notifications_index"
    post "notifications/create" => 'notifications#create', :as => "notifications_create"
    get "notifications/reset_password/:token" => "notifications#reset_password", :as => "notifications_reset_password"


    resources :info_social_networks, :except => [:show]

    resources :social_networks, :except => [:show]
    get "social_networks/new/:isn" => "social_networks#new", :as => "social_networks_new"
    post "social_networks/add_image" => "social_networks#add_image", :as => "social_networks_add_image"
    post "social_networks/update_comment" => "social_networks#update_comment_image", :as => "social_networks_update_comment"
    delete "social_networks/destroy_image/:id" => "social_networks#destroy_image", :as => "social_networks_destroy_image"
    delete "social_networks/:id" => "social_networks#destroy", :as => "social_networks_delete"

    get "validate_user/" => "home#validate_user", :as => "validate_user"
    get "/" => "home#index", :as => "root2"

  end

  root :to => "home#index", :locale => "es"
end
