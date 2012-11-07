class AddChartFieldCampaignComments < ActiveRecord::Migration
  def up
    add_column :campaign_comments, :chart, :text
  end

  def down
    remove_column :campaign_comments, :chart
  end
end
