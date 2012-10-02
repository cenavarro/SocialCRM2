require 'spec_helper'

describe "blog_data/show" do
  before(:each) do
    @blog_datum = assign(:blog_datum, stub_model(BlogDatum,
      :client_id => 1,
      :social_network_id => 2,
      :unique_visits => 3,
      :visit_pages => 4,
      :rebound_percent => 1.5,
      :new_visits_percent => 1.5,
      :total_posts => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/5/)
  end
end
