class CreateBlogData < ActiveRecord::Migration
  def change
    create_table :blog_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :unique_visits
      t.integer :visit_pages
      t.float :rebound_percent
      t.float :new_visits_percent
      t.integer :total_posts

      t.timestamps
    end
  end
end
