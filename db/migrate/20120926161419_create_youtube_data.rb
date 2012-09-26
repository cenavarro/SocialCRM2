class CreateYoutubeData < ActiveRecord::Migration
  def change
    create_table :youtube_data do |t|
      t.integer :client_id
      t.date :start_date
      t.date :end_date
      t.integer :social_network_id
      t.integer :new_subscriber
      t.integer :total_subscriber
      t.integer :total_video_views
      t.integer :inserted_player
      t.float :mobile_devise
      t.float :youtube_search
      t.float :youtube_suggestion
      t.float :youtube_page
      t.float :external_web_site
      t.float :google_search
      t.float :youtube_others
      t.float :youtube_subscriptions
      t.float :youtube_ads
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_anno

      t.timestamps
    end
  end
end
