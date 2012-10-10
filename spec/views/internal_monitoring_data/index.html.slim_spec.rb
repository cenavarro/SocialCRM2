require 'spec_helper'

describe "internal_monitoring_data/index" do
  before(:each) do
    assign(:internal_monitoring_data, [
      stub_model(InternalMonitoringDatum,
        :client_id => 1,
        :social_network_id => 2,
        :complaints => 3,
        :client_att => 4,
        :lead => 5,
        :engaged => 6,
        :curiosities => 7,
        :mentions => 8,
        :feedback => 9,
        :channel_1 => 10,
        :channel_2 => 11,
        :channel_3 => 12,
        :channel_4 => 13,
        :channel_5 => 14,
        :channel_6 => 15,
        :channel_7 => 16,
        :channel_8 => 17,
        :channel_9 => 18,
        :channel_10 => 19,
        :channel_11 => 20,
        :channel_12 => 21,
        :channel_13 => 22,
        :channel_14 => 23,
        :channel_15 => 24,
        :channel_16 => 25,
        :channel_17 => 26,
        :channel_18 => 27,
        :channel_19 => 28,
        :channel_20 => 29
      ),
      stub_model(InternalMonitoringDatum,
        :client_id => 1,
        :social_network_id => 2,
        :complaints => 3,
        :client_att => 4,
        :lead => 5,
        :engaged => 6,
        :curiosities => 7,
        :mentions => 8,
        :feedback => 9,
        :channel_1 => 10,
        :channel_2 => 11,
        :channel_3 => 12,
        :channel_4 => 13,
        :channel_5 => 14,
        :channel_6 => 15,
        :channel_7 => 16,
        :channel_8 => 17,
        :channel_9 => 18,
        :channel_10 => 19,
        :channel_11 => 20,
        :channel_12 => 21,
        :channel_13 => 22,
        :channel_14 => 23,
        :channel_15 => 24,
        :channel_16 => 25,
        :channel_17 => 26,
        :channel_18 => 27,
        :channel_19 => 28,
        :channel_20 => 29
      )
    ])
  end

  it "renders a list of internal_monitoring_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
    assert_select "tr>td", :text => 16.to_s, :count => 2
    assert_select "tr>td", :text => 17.to_s, :count => 2
    assert_select "tr>td", :text => 18.to_s, :count => 2
    assert_select "tr>td", :text => 19.to_s, :count => 2
    assert_select "tr>td", :text => 20.to_s, :count => 2
    assert_select "tr>td", :text => 21.to_s, :count => 2
    assert_select "tr>td", :text => 22.to_s, :count => 2
    assert_select "tr>td", :text => 23.to_s, :count => 2
    assert_select "tr>td", :text => 24.to_s, :count => 2
    assert_select "tr>td", :text => 25.to_s, :count => 2
    assert_select "tr>td", :text => 26.to_s, :count => 2
    assert_select "tr>td", :text => 27.to_s, :count => 2
    assert_select "tr>td", :text => 28.to_s, :count => 2
    assert_select "tr>td", :text => 29.to_s, :count => 2
  end
end
