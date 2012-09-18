class AddFieldReachCommentFacebookComments < ActiveRecord::Migration
  def up
    add_column :facebook_comments, :reach, :string
  end

  def down
    remove_column :facebook_comments, :reach
  end
end
