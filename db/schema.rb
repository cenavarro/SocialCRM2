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

ActiveRecord::Schema.define(:version => 20120924165709) do

  create_table "clients", :force => true do |t|
    t.string   "name",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",             :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "facebook_comments", :force => true do |t|
    t.integer  "social_network_id"
    t.string   "table"
    t.string   "fans"
    t.string   "interaction"
    t.string   "investment"
    t.string   "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reach"
  end

  add_index "facebook_comments", ["social_network_id"], :name => "index_facebook_comments_on_social_network", :unique => true

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
    t.integer  "id_social_network"
  end

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
  end

  create_table "linkedin_comments", :force => true do |t|
    t.integer  "social_network_id"
    t.text     "table"
    t.text     "comunity"
    t.text     "interaction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linkedin_data", :force => true do |t|
    t.integer  "new_followers"
    t.integer  "total_followers"
    t.integer  "summary"
    t.integer  "employment"
    t.integer  "products_services"
    t.integer  "prints"
    t.integer  "clics"
    t.integer  "recommendation"
    t.integer  "shared"
    t.float    "investment_agency"
    t.float    "investment_actions"
    t.float    "investment_anno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "interest"
    t.integer  "id_social_network"
  end

  create_table "revisions", :force => true do |t|
    t.text     "comment"
    t.text     "suggestion"
    t.text     "company_comment"
    t.boolean  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rols", :force => true do |t|
    t.string   "name"
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

  create_table "twitter_comments", :force => true do |t|
    t.integer  "social_network_id"
    t.text     "table"
    t.text     "comunity"
    t.text     "interaction"
    t.text     "investment"
    t.text     "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.float    "cost_follower"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "investment_actions"
    t.integer  "interactions_ads"
    t.integer  "prints"
    t.integer  "prints_ads"
    t.float    "cost_twitter_ads"
    t.float    "investment_ads"
    t.integer  "id_social_network"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
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

end
