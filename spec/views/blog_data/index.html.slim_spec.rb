require 'spec_helper'

describe "blog_data/index" do
  before(:each) do
    assign(:blog_data, [
      stub_model(BlogDatum,
        :client_id => 1,
        :social_network_id => 2,
        :unique_visits => 3,
        :visit_pages => 4,
        :rebound_percent => 1.5,
        :new_visits_percent => 1.5,
        :total_posts => 5
      ),
      stub_model(BlogDatum,
        :client_id => 1,
        :social_network_id => 2,
        :unique_visits => 3,
        :visit_pages => 4,
        :rebound_percent => 1.5,
        :new_visits_percent => 1.5,
        :total_posts => 5
      )
    ])
  end

  it "renders a list of blog_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
