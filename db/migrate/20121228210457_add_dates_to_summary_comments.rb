class AddDatesToSummaryComments < ActiveRecord::Migration
  def up
    add_column :summary_comments, :start_date, :date 
    add_column :summary_comments, :end_date, :date 
  end

  def down 
    remove_column :summary_comments, :start_date
    remove_column :summary_comments, :end_date
  end
end
