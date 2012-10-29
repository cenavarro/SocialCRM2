require 'spec_helper'

describe BlogDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes
    { :client_id => 1, :social_network_id => 1, :start_date => "01-01-2012".to_date, :end_date => "31-01-2012".to_date, :unique_visits => 1, :view_pages => 2,
    :rebound_percent => 3, :new_visits_percent => 4.0, :total_posts => 5}
  end

  def invalid_attributes
    { :client_id => "text", :social_network_id => 1, :start_date => "01-01-2012".to_date, :end_date => "31-01-2012".to_date, :unique_visits => 1, :view_pages => 2,
    :rebound_percent => 3, :new_visits_percent => 4.0, :total_posts => 5}
  end

  describe "#index" do
    it "assigns all blog_data as @blog_datum" do
      blog_datum = BlogDatum.create! valid_attributes
      get :index, :locale => :es, :idc => 1, :opcion => 1, :id_social => 1 
      assigns(:blog_datum).should eq([blog_datum])
    end

    it "assigns blog_data as @blog_datum in a date range" do
      blog_datum = BlogDatum.create! valid_attributes
      get :index, :locale => :es, :idc => 1, :opcion => 2, :id_social => 1, :start_date => "01-01-2012", :end_date => "31-01-2012" 
      assigns(:blog_datum).should eq([blog_datum])
    end

  end

  describe "#new" do
    it "assigns a new blog_datum as @blog_datum" do
      get :new, :locale => :es, :idc => 1, :opcion => 2, :id_social => 1
      assigns(:blog_datum).should be_a_new(BlogDatum)
    end
  end

  describe "#edit" do
    it "assigns the requested blog_datum as @blog_datum" do
      blog_datum = BlogDatum.create! valid_attributes
      get :edit, :locale => :es, :id => blog_datum.to_param, :idc => 1, :id_social => 1
      assigns(:blog_datum).should eq(blog_datum)
    end
  end

  describe "#create" do
    context "with valid params" do
      it "creates a new BlogDatum" do
        expect {
          post :create, :locale => :es, :blog_datum => valid_attributes
        }.to change(BlogDatum, :count).by(1)
      end

      it "assigns a newly created blog_datum as @blog_datum" do
        post :create, :locale => :es,  :blog_datum => valid_attributes
        assigns(:blog_datum).should be_a(BlogDatum)
        assigns(:blog_datum).should be_persisted
      end

    end

    context "with invalid params" do
      it "assigns a newly created but unsaved blog_datum as @blog_datum" do
        BlogDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es, :blog_datum => invalid_attributes
        assigns(:blog_datum).should be_a_new(BlogDatum)
      end

      it "re-renders the 'new' template" do
        BlogDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es, :blog_datum => invalid_attributes
        response.should render_template("new")
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      it "updates the requested blog_datum" do
        blog_datum = BlogDatum.create! valid_attributes
        put :update, :locale => :es,  :id => blog_datum.to_param, :blog_datum => {'client_id' => '5'}
        blog_datum = BlogDatum.find_by_client_id(5).should_not be_nil
      end

      it "assigns the requested blog_datum as @blog_datum" do
        blog_datum = BlogDatum.create! valid_attributes
        put :update, :locale => :es, :id => blog_datum.to_param, :blog_datum => valid_attributes
        assigns(:blog_datum).should eq(blog_datum)
      end

    end

    context "with invalid params" do
      it "assigns the blog_datum as @blog_datum" do
        blog_datum = BlogDatum.create! valid_attributes
        put :update, :locale => :es,  :id => blog_datum.to_param, :blog_datum => invalid_attributes
        assigns(:blog_datum).should eq(blog_datum)
      end

      it "re-renders the 'edit' template" do
        blog_datum = BlogDatum.create! valid_attributes
        BlogDatum.any_instance.stub(:save).and_return(false)
        put :update, :locale => :es,  :id => blog_datum.to_param, :blog_datum => {'client_id' => 'text'}
        response.should render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested blog_datum" do
      blog_datum = BlogDatum.create! valid_attributes
      expect {
        delete :destroy, :locale => :es, :id => blog_datum.to_param
      }.to change(BlogDatum, :count).by(-1)
    end

    it "redirects to the index page" do
      blog_datum = BlogDatum.create! valid_attributes
      delete :destroy, :locale => :es, :id => blog_datum.to_param
      response.should redirect_to(blog_index_path(1,1,1))
    end
  end

  describe "#save_comment" do
    it "update a comments of a BlogComment given a social network" do
      BlogComment.create!({:social_network_id => 1})
      post :save_comment, :locale => :es, :comment => "Comment Table Test", :id_comment => "table", :social_network => 1
      post :save_comment, :locale => :es, :comment => "Comment Visits Test", :id_comment => "visits", :social_network => 1
      post :save_comment, :locale => :es, :comment => "Comment Percentages Test", :id_comment => "percentages", :social_network => 1
      datum_comments = BlogComment.find_by_social_network_id(1)
      datum_comments.table.should eq("Comment Table Test")
      datum_comments.visits.should eq("Comment Visits Test")
      datum_comments.percentages.should eq("Comment Percentages Test")
    end
  end

end
