class ChangeOnLinkedin < ActiveRecord::Migration
  def up
    remove_column :linkedin_data, :new_followers
    remove_column :linkedin_data, :shared
    add_column :linkedin_data, :actions, :text
    add_column :linkedin_comments, :pages_views, :text
  end

  def down
    add_column :linkedin_data, :new_followers, :integer
    add_column :linkedin_data, :shared, :integer
    remove_column :linkedin_data, :actions
    remove_column :linkedin_comments, :pages_views
  end
end
