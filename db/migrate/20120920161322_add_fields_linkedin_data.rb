class AddFieldsLinkedinData < ActiveRecord::Migration
  def up
    add_column :linkedin_data, :client_id, :integer
    add_column :linkedin_data, :start_date, :date
    add_column :linkedin_data, :end_date, :date
    add_column :linkedin_data, :interest, :float
  end

  def down
    remove_column :linkedin_data, :client_id
    remove_column :linkedin_data, :start_date
    remove_column :linkedin_data, :end_date
    remove_column :linkedin_data, :interest
  end
end
