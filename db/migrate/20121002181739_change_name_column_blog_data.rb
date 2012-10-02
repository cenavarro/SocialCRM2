class ChangeNameColumnBlogData < ActiveRecord::Migration
  def up
    rename_column :blog_data, :visit_pages, :view_pages
  end

  def down
  end
end
