class DeleteCommentTablesSocialNetworks < ActiveRecord::Migration
  def up
    drop_table :benchmark_comments if self.table_exists?("benchmark_comments")
    drop_table :blog_comments if self.table_exists?("blog_comments")
    drop_table :campaign_comments if self.table_exists?("campaign_comments")
    drop_table :facebook_comments if self.table_exists?("facebook_comments")
    drop_table :flickr_comments if self.table_exists?("flickr_comments")
    drop_table :foursquare_comments if self.table_exists?("foursquare_comments")
    drop_table :google_plus_comments if self.table_exists?("google_plus_comments")
    drop_table :linkedin_comments if self.table_exists?("linkedin_comments")
    drop_table :monitoring_comments if self.table_exists?("monitoring_comments")
    drop_table :pinterest_comments if self.table_exists?("pinterest_comments")
    drop_table :tuenti_comments if self.table_exists?("tuenti_comments")
    drop_table :tumblr_comments if self.table_exists?("tumblr_comments")
    drop_table :twitter_comments if self.table_exists?("twitter_comments")
    drop_table :youtube_comments if self.table_exists?("youtube_comments")
    drop_table :rols if self.table_exists?("rols")
  end

end
