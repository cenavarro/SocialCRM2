require 'spec_helper'

describe "blog_data/edit" do
  before(:each) do
    @blog_datum = assign(:blog_datum, stub_model(BlogDatum,
      :client_id => 1,
      :social_network_id => 1,
      :unique_visits => 1,
      :visit_pages => 1,
      :rebound_percent => 1.5,
      :new_visits_percent => 1.5,
      :total_posts => 1
    ))
  end

  it "renders the edit blog_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => blog_data_path(@blog_datum), :method => "post" do
      assert_select "input#blog_datum_client_id", :name => "blog_datum[client_id]"
      assert_select "input#blog_datum_social_network_id", :name => "blog_datum[social_network_id]"
      assert_select "input#blog_datum_unique_visits", :name => "blog_datum[unique_visits]"
      assert_select "input#blog_datum_visit_pages", :name => "blog_datum[visit_pages]"
      assert_select "input#blog_datum_rebound_percent", :name => "blog_datum[rebound_percent]"
      assert_select "input#blog_datum_new_visits_percent", :name => "blog_datum[new_visits_percent]"
      assert_select "input#blog_datum_total_posts", :name => "blog_datum[total_posts]"
    end
  end
end
