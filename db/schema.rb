# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130109143432) do

  create_table "benchmark_competitors", :force => true do |t|
    t.integer  "social_network_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "benchmark_data", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "blogs"
    t.integer  "forums"
    t.integer  "videos"
    t.integer  "twitter"
    t.integer  "facebook"
    t.integer  "others"
    t.integer  "benchmark_competitor_id", :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "unique_visits"
    t.integer  "view_pages"
    t.float    "rebound_percent"
    t.float    "new_visits_percent"
    t.integer  "total_posts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.text     "social_network_name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "comment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_data", :force => true do |t|
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "actions"
    t.integer  "new_fans"
    t.integer  "total_fans"
    t.integer  "goal_fans"
    t.integer  "prints"
    t.integer  "total_interactions"
    t.integer  "total_reach"
    t.integer  "potential_reach"
    t.float    "total_prints_per_anno"
    t.integer  "total_prints"
    t.integer  "total_clicks_anno"
    t.integer  "fans_through_anno"
    t.float    "agency_investment"
    t.float    "new_stock_investment"
    t.float    "anno_investment"
    t.float    "ctr_anno"
    t.float    "cpm_anno"
    t.float    "cpc_anno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking_espana"
    t.integer  "ranking_world"
    t.integer  "social_network_id"
  end

  create_table "flickr_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "new_contacts"
    t.integer  "total_contacts"
    t.integer  "visits"
    t.integer  "comments"
    t.integer  "favorites"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_ads"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foursquare_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "new_followers"
    t.integer  "total_followers"
    t.integer  "total_unlocks"
    t.integer  "total_visits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clients"
    t.integer  "likes"
    t.integer  "checkins"
  end

  create_table "google_plus_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "new_followers"
    t.integer  "total_followers"
    t.integer  "plus"
    t.integer  "content_shared"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_ads"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "history_comments", :force => true do |t|
    t.integer  "social_network_id"
    t.integer  "comment_id"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_comments", ["social_network_id"], :name => "index_history_comments_on_social_network_id"

  create_table "images_social_networks", :force => true do |t|
    t.integer  "social_network_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "info_social_networks", :force => true do |t|
    t.string   "name",                    :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "id_name"
  end

  create_table "internal_monitoring_channels", :force => true do |t|
    t.integer  "social_network_id"
    t.integer  "channel_number"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_data", :force => true do |t|
    t.integer  "total_followers"
    t.integer  "summary"
    t.integer  "employment"
    t.integer  "products_services"
    t.integer  "prints"
    t.integer  "clics"
    t.integer  "recommendation"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_anno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "interest"
    t.integer  "social_network_id"
    t.text     "actions"
  end

  create_table "list_comments", :force => true do |t|
    t.integer  "comment_id"
    t.text     "content"
    t.text     "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_comments", ["comment_id"], :name => "index_list_comments_on_comment_id"

  create_table "monitoring_data", :force => true do |t|
    t.integer  "monitoring_id"
    t.integer  "value"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitorings", :force => true do |t|
    t.string   "name"
    t.integer  "social_network_id"
    t.boolean  "isTheme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pinterest_data", :force => true do |t|
    t.integer  "new_followers"
    t.integer  "total_followers"
    t.integer  "boards"
    t.integer  "pins"
    t.integer  "liked"
    t.integer  "repin"
    t.integer  "comments"
    t.integer  "community_boards"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_ads"
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "social_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "row_data", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "value"
    t.integer  "rows_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rows_campaigns", :force => true do |t|
    t.string   "name"
    t.integer  "social_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networks", :force => true do |t|
    t.string   "name",                   :null => false
    t.integer  "client_id",              :null => false
    t.integer  "info_social_network_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_object"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "summaries", :force => true do |t|
    t.integer  "social_network_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summary_comments", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "tuenti_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "new_fans"
    t.integer  "real_fans"
    t.integer  "goal_fans"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_ads"
    t.float    "cost_fan"
    t.integer  "page_prints"
    t.integer  "unique_total_users"
    t.integer  "external_clics"
    t.integer  "clics"
    t.integer  "downloads"
    t.integer  "comments"
    t.float    "ctr_external_clics"
    t.integer  "upload_photos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "actions"
  end

  create_table "tumblr_data", :force => true do |t|
    t.integer  "client_id"
    t.integer  "social_network_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "total_followers"
    t.integer  "likes"
    t.integer  "reblogged"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_ads"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts"
  end

  create_table "twitter_data", :force => true do |t|
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "global_goal"
    t.integer  "new_followers"
    t.integer  "total_followers"
    t.integer  "goal_followers"
    t.integer  "total_tweets"
    t.integer  "total_mentions"
    t.integer  "ret_tweets"
    t.integer  "total_clicks"
    t.integer  "total_interactions"
    t.float    "agency_investment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interactions_ads"
    t.integer  "prints"
    t.integer  "prints_ads"
    t.float    "investment_actions"
    t.float    "cost_twitter_ads"
    t.float    "investment_ads"
    t.integer  "social_network_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "rol_id"
    t.integer  "client_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "youtube_data", :force => true do |t|
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "social_network_id"
    t.integer  "total_subscriber"
    t.integer  "total_video_views"
    t.integer  "inserted_player"
    t.float    "mobile_devise"
    t.float    "youtube_search"
    t.float    "youtube_suggestion"
    t.float    "youtube_page"
    t.float    "external_web_site"
    t.float    "google_search"
    t.float    "youtube_others"
    t.float    "youtube_subscriptions"
    t.float    "youtube_ads"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_anno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes"
    t.integer  "no_likes"
    t.integer  "favorite"
    t.integer  "comments"
    t.integer  "shared"
  end

end
