DemoComentarios::Application.routes.draw do

  get "/:locale" => "home#index", :as => "language"

  scope ':locale' do

    post "comment" => "comment#create", :as => "comment"
    put "comment" => "comment#update", :as => "comment_update"
    get "comment_data/new/:idc/:opcion/:id_social" => "comment#new", :as => "comment_new"
    get "comment_data/:idc/:opcion/:id_social" => "comment#index", :as => "comment_index"
    get "comment/:id/edit/:idc/:id_social" => "comment#edit", :as => "comment_edit"
    delete "comment/:id" => "comment#destroy", :as => "comment_destroy"

    resources :summaries, :only => [:create, :update]
    get "summary_data/new/:idc/:opcion/:id_social" => "summaries#new", :as => "summary_new"
    get "summary_data/:id/edit/:idc/:id_social" => "summaries#edit", :as => "summary_edit"
    get "summary_data/:idc(/:opcion)/:id_social" => "summaries#index", :as => "summary_index"
    delete "summaries/:id/:idc/:id_social" => "summaries#destroy", :as => "summary_delete"

    get "monitoring_data/new/:idc/:id_social" => "monitoring#new", :as => "monitoring_new"
    get "monitoring_data/:id/edit/:idc/:id_social" => "monitoring#edit", :as => "monitoring_edit"
    post "monitoring/:idc/:id_social" => "monitoring#create", :as => "monitoring"
    post "monitoring" => "monitoring#update", :as => "monitoring_update"
    get "monitoring_data/:idc/:opcion/:id_social" => "monitoring#index", :as => "monitoring_index"
    delete "monitoring/:idc/:id_social/:id" => "monitoring#destroy", :as => "monitoring_datum"

    get "campaign_data/new/:idc/:id_social" => "campaign_data#new", :as => "campaign_new"
    get "campaign_data/:id/edit/:idc/:id_social" => "campaign_data#edit", :as => "campaign_edit"
    post "campaign_data/:idc/:id_social" => "campaign_data#create", :as => "campaign_data"
    post "campaign_data" => "campaign_data#update", :as => "campaign_update"
    get "campaign_data/:idc/:opcion/:id_social" => "campaign_data#index", :as => "campaign_index"
    delete "campaign_data/:idc/:id_social/:id" => "campaign_data#destroy", :as => "campaign_datum"

    resources :benchmark_data, :only => [:create, :destroy, :update]
    get "benchmark_data/new/:idc/:opcion/:id_social" => "benchmark_data#new", :as => "benchmark_new"
    get "benchmark_data/:id/edit/:idc/:id_social" => "benchmark_data#edit", :as => "benchmark_edit"
    get "benchmark_data/:idc/:opcion/:id_social" => "benchmark_data#index", :as => "benchmark_index"

    resources :foursquare_data, :only => [:create, :destroy, :update]
    get "foursquare_data/new/:idc/:opcion/:id_social" => "foursquare_data#new", :as => "foursquare_new"
    get "foursquare_data/:id/edit/:idc/:id_social" => "foursquare_data#edit", :as => "foursquare_edit"
    get "foursquare_data/:idc/:opcion/:id_social" => "foursquare_data#index", :as => "foursquare_index"

    resources :tumblr_data, :only => [:create, :destroy, :update]
    get "tumblr_data/new/:idc/:opcion/:id_social" => "tumblr_data#new", :as => "tumblr_new"
    get "tumblr_data/:id/edit/:idc/:id_social" => "tumblr_data#edit", :as => "tumblr_edit"
    get "tumblr_data/:idc/:opcion/:id_social" => "tumblr_data#index", :as => "tumblr_index"

    resources :blog_data, :only => [:create, :destroy, :update]
    get "blog_data/new/:idc/:opcion/:id_social" => "blog_data#new", :as => "blog_new"
    get "blog_data/:id/edit/:idc/:id_social" => "blog_data#edit", :as => "blog_edit"
    get "blog_data/:idc/:opcion/:id_social" => "blog_data#index", :as => "blog_index"

    resources :google_plus_data, :only => [:create, :destroy, :update]
    get "google_plus_data/new/:idc/:opcion/:id_social" => "google_plus_data#new", :as => "google_plus_new"
    get "google_plus_data/:id/edit/:idc/:id_social" => "google_plus_data#edit", :as => "google_plus_edit"
    get "google_plus_data/:idc/:opcion/:id_social" => "google_plus_data#index", :as => "google_plus_index"

    resources :flickr_data, :only => [:create, :destroy, :update]
    get "flickr_data/new/:idc/:opcion/:id_social" => "flickr_data#new", :as => "flickr_new"
    get "flickr_data/:id/edit/:idc/:id_social" => "flickr_data#edit", :as => "flickr_edit"
    get "flickr_data/:idc/:opcion/:id_social" => "flickr_data#index", :as => "flickr_index"

    resources :tuenti_data, :only => [:create, :destroy, :update]
    get "tuenti_data/new/:idc/:opcion/:id_social" => "tuenti_data#new", :as => "tuenti_new"
    get "tuenti_data/:id/edit/:idc/:id_social" => "tuenti_data#edit", :as => "tuenti_edit"
    get "tuenti_data/:idc/:opcion/:id_social" => "tuenti_data#index", :as => "tuenti_index"

    resources :youtube_data, :only => [:create, :destroy, :update]
    get "youtube_data/new/:idc/:opcion/:id_social" => "youtube_data#new", :as => "youtube_new"
    get "youtube_data/:id/edit/:idc/:id_social" => "youtube_data#edit", :as => "youtube_edit"
    get "youtube_data/:idc/:opcion/:id_social" => "youtube_data#index", :as => "youtube_index"

    resources :pinterest_data, :only => [:create, :destroy, :update]
    get "pinterest_data/new/:idc/:opcion/:id_social" => "pinterest_data#new", :as => "pinterest_new"
    get "pinterest_data/:id/edit/:idc/:id_social" => "pinterest_data#edit", :as => "pinterest_edit"
    get "pinterest_data/:idc/:opcion/:id_social" => "pinterest_data#index", :as => "pinterest_index"

    resources :linkedin_data, :only => [:create, :destroy, :update]
    get "linkedin_data/new/:idc/:opcion/:id_social" => "linkedin_data#new", :as => "linkedin_new"
    get "linkedin_data/:id/edit/:idc/:id_social" => "linkedin_data#edit", :as => "linkedin_edit"
    get "linkedin_data/:idc/:opcion/:id_social" => "linkedin_data#index", :as => "linkedin_index"

    resources :twitter_data, :only => [:create, :destroy, :update]
    get "twitter_data/new/:idc/:opcion/:id_social" => "twitter_data#new", :as => "twitter_new"
    get "twitter_data/:id/edit/:idc/:id_social" => "twitter_data#edit", :as => "twitter_edit"
    get "twitter_data/:idc/:opcion/:id_social" => "twitter_data#index", :as => "twitter_index"

    resources :facebook_data, :only => [:create, :destroy, :update]
    get "facebook_data/:id/edit/:idc/:id_social" => "facebook_data#edit", :as => "facebook_edit"
    get "facebook_data/:idc/:opcion/:id_social" => "facebook_data#index", :as => "facebook_index"
    get "facebook_data/new/:idc/:opcion/:id_social(/:start_date/:end_date/:access_token)" => "facebook_data#new", :as => "facebook_new"
    get "facebook_data/callback/:idc/:id_social/:start_date/:end_date" => "facebook_data#callback", :as => "facebook_callback_dates"
    get "facebook_data/callback/:idc/:id_social" => "facebook#callback", :as => "facebook_callback"

    devise_for :users, :controllers => {:omniauth_callbacks => "auth"}

    resources :clients, :except => [:show]
    get 'clients/social_networks/:idc' => 'clients#social_networks', :as => "clients_social_networks"
    get 'clients/facebook' => 'clients#facebook', :as => "client_facebook"
    post 'clients/insert_social_network' => 'clients#insert_social_network', :as => "clients_insert_social_network"
    get 'clients/generate_report(/social_network_id)' => 'clients#generate_report', :as => "client_generate_report"
    get 'clients/reports' => 'clients#reports', :as => "client_reports"

    get "users/new/:option" => "users#new", :as => "new_user"
    get 'users/delete' => 'users#delete', :as => "users_delete"
    put 'users/destroy' => 'users#destroy', :as => "users_destroy"
    post 'users/create' => 'users#create', :as => "users_create"

    get "notifications/index" => 'notifications#index', :as => "notifications_index"
    post "notifications/create" => 'notifications#create', :as => "notifications_create"
    get "notifications/reset_password/:token" => "notifications#reset_password", :as => "notifications_reset_password"


    resources :info_social_networks, :except => [:show]

    resources :social_networks, :except => [:new, :show]
    get "social_networks/new/:isn" => "social_networks#new", :as => "social_networks_new"
    post "social_networks/new_redirect" => "social_networks#redirect", :as => "social_networks_redirect_new"
    get "social_networks/new_campaign" => "social_networks#new_campaign", :as => "social_networks_new_campaign"
    get "social_networks/new_monitoring" => "social_networks#new_monitoring", :as => "social_networks_new_monitoring"
    get "social_networks/new_benchmark" => "social_networks#new_benchmark", :as => "social_networks_new_benchmark"
    post "social_networks/create_campaign" => "social_networks#create_campaign", :as => "social_networks_create_campaing"
    post "social_networks/create_monitoring" => "social_networks#create_monitoring", :as => "social_networks_create_monitoring"
    post "social_networks/create_benchmark" => "social_networks#create_benchmark", :as => "social_networks_create_benchmark"

    post "images_social_network/update_comment" => "images_social_network#update_comment", :as => "images_social_network_update_comment"
    post "images_social_network/new" => "images_social_network#new", :as => "images_social_network_new"
    delete "images_social_network/destroy/:id" => "images_social_network#destroy", :as => "images_social_network_destroy"
    post "images_social_network/update/:id" => "images_social_network#update", :as => "images_social_network_update"

    post "history_comments/new" => "history_comment#new", :as => "history_comment_new"
    delete "history_comments/destroy/:id" => "history_comment#destroy", :as => "history_comment_destroy"

  end

    get "validate_user/" => "home#validate_user", :as => "validate_user"
    get "/" => "home#index", :as => "root2"

    root :to => "home#index"
end
