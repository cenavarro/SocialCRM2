require 'spec_helper'

describe "internal_monitoring_data/edit" do
  before(:each) do
    @internal_monitoring_datum = assign(:internal_monitoring_datum, stub_model(InternalMonitoringDatum,
      :client_id => 1,
      :social_network_id => 1,
      :complaints => 1,
      :client_att => 1,
      :lead => 1,
      :engaged => 1,
      :curiosities => 1,
      :mentions => 1,
      :feedback => 1,
      :channel_1 => 1,
      :channel_2 => 1,
      :channel_3 => 1,
      :channel_4 => 1,
      :channel_5 => 1,
      :channel_6 => 1,
      :channel_7 => 1,
      :channel_8 => 1,
      :channel_9 => 1,
      :channel_10 => 1,
      :channel_11 => 1,
      :channel_12 => 1,
      :channel_13 => 1,
      :channel_14 => 1,
      :channel_15 => 1,
      :channel_16 => 1,
      :channel_17 => 1,
      :channel_18 => 1,
      :channel_19 => 1,
      :channel_20 => 1
    ))
  end

  it "renders the edit internal_monitoring_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => internal_monitoring_data_path(@internal_monitoring_datum), :method => "post" do
      assert_select "input#internal_monitoring_datum_client_id", :name => "internal_monitoring_datum[client_id]"
      assert_select "input#internal_monitoring_datum_social_network_id", :name => "internal_monitoring_datum[social_network_id]"
      assert_select "input#internal_monitoring_datum_complaints", :name => "internal_monitoring_datum[complaints]"
      assert_select "input#internal_monitoring_datum_client_att", :name => "internal_monitoring_datum[client_att]"
      assert_select "input#internal_monitoring_datum_lead", :name => "internal_monitoring_datum[lead]"
      assert_select "input#internal_monitoring_datum_engaged", :name => "internal_monitoring_datum[engaged]"
      assert_select "input#internal_monitoring_datum_curiosities", :name => "internal_monitoring_datum[curiosities]"
      assert_select "input#internal_monitoring_datum_mentions", :name => "internal_monitoring_datum[mentions]"
      assert_select "input#internal_monitoring_datum_feedback", :name => "internal_monitoring_datum[feedback]"
      assert_select "input#internal_monitoring_datum_channel_1", :name => "internal_monitoring_datum[channel_1]"
      assert_select "input#internal_monitoring_datum_channel_2", :name => "internal_monitoring_datum[channel_2]"
      assert_select "input#internal_monitoring_datum_channel_3", :name => "internal_monitoring_datum[channel_3]"
      assert_select "input#internal_monitoring_datum_channel_4", :name => "internal_monitoring_datum[channel_4]"
      assert_select "input#internal_monitoring_datum_channel_5", :name => "internal_monitoring_datum[channel_5]"
      assert_select "input#internal_monitoring_datum_channel_6", :name => "internal_monitoring_datum[channel_6]"
      assert_select "input#internal_monitoring_datum_channel_7", :name => "internal_monitoring_datum[channel_7]"
      assert_select "input#internal_monitoring_datum_channel_8", :name => "internal_monitoring_datum[channel_8]"
      assert_select "input#internal_monitoring_datum_channel_9", :name => "internal_monitoring_datum[channel_9]"
      assert_select "input#internal_monitoring_datum_channel_10", :name => "internal_monitoring_datum[channel_10]"
      assert_select "input#internal_monitoring_datum_channel_11", :name => "internal_monitoring_datum[channel_11]"
      assert_select "input#internal_monitoring_datum_channel_12", :name => "internal_monitoring_datum[channel_12]"
      assert_select "input#internal_monitoring_datum_channel_13", :name => "internal_monitoring_datum[channel_13]"
      assert_select "input#internal_monitoring_datum_channel_14", :name => "internal_monitoring_datum[channel_14]"
      assert_select "input#internal_monitoring_datum_channel_15", :name => "internal_monitoring_datum[channel_15]"
      assert_select "input#internal_monitoring_datum_channel_16", :name => "internal_monitoring_datum[channel_16]"
      assert_select "input#internal_monitoring_datum_channel_17", :name => "internal_monitoring_datum[channel_17]"
      assert_select "input#internal_monitoring_datum_channel_18", :name => "internal_monitoring_datum[channel_18]"
      assert_select "input#internal_monitoring_datum_channel_19", :name => "internal_monitoring_datum[channel_19]"
      assert_select "input#internal_monitoring_datum_channel_20", :name => "internal_monitoring_datum[channel_20]"
    end
  end
end
