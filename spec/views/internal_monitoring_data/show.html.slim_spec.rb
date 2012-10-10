require 'spec_helper'

describe "internal_monitoring_data/show" do
  before(:each) do
    @internal_monitoring_datum = assign(:internal_monitoring_datum, stub_model(InternalMonitoringDatum,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/12/)
    rendered.should match(/13/)
    rendered.should match(/14/)
    rendered.should match(/15/)
    rendered.should match(/16/)
    rendered.should match(/17/)
    rendered.should match(/18/)
    rendered.should match(/19/)
    rendered.should match(/20/)
    rendered.should match(/21/)
    rendered.should match(/22/)
    rendered.should match(/23/)
    rendered.should match(/24/)
    rendered.should match(/25/)
    rendered.should match(/26/)
    rendered.should match(/27/)
    rendered.should match(/28/)
    rendered.should match(/29/)
  end
end
