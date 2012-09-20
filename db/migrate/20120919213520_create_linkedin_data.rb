class CreateLinkedinData < ActiveRecord::Migration
  def change
    create_table :linkedin_data do |t|
      t.integer :new_followers
      t.integer :total_followers
      t.integer :summary
      t.integer :employment
      t.integer :products_services
      t.integer :prints
      t.integer :clics
      t.integer :recommendation
      t.integer :shared
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_anno

      t.timestamps
    end
  end
end
