require 'spec_helper'

describe "tuenti_data/show" do
  before(:each) do
    @tuenti_datum = assign(:tuenti_datum, stub_model(TuentiDatum,
      :client_id => 1,
      :social_network_id => 2,
      :new_fans => 3,
      :real_fans => 4,
      :goal_fans => 5,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5,
      :cost_fan => 1.5,
      :page_prints => 6,
      :unique_total_users => 7,
      :external_clics => 8,
      :clics => 9,
      :downloads => 10,
      :comments => 11,
      :ctr_external_clics => 1.5,
      :upload_photos => 12
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
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/1.5/)
    rendered.should match(/12/)
  end
end
