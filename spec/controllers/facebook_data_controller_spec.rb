require 'spec_helper'

describe FacebookDataController do
  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes
    { :client_id => 1, :start_date => "2012/08/1".to_date, :end_date => "2012/08/15".to_date, :actions => "Test Action", :new_fans => 10,
      :total_fans => 10, :goal_fans => 10, :prints => 100, :total_interactions => 100, :total_reach => 100, :potential_reach => 100,
      :total_prints_per_anno => 100, :total_prints => 100, :total_clicks_anno => 100, :fans_through_anno => 20, :agency_investment => 137.5,
      :new_stock_investment => 1500.0, :anno_investment => 2200.5, :ctr_anno => 0.096, :cpm_anno => 0.09, :cpc_anno => 0.1,
      :ranking_world => 100, :ranking_espana => 10, :social_network_id => 1
    }
  end

  def valid_attributes2
    { :client_id => 1, :start_date => "2012/08/16".to_date, :end_date => "2012/08/30".to_date, :actions => "Test Action 2", :new_fans => 20,
      :total_fans => 20, :goal_fans => 20, :prints => 200, :total_interactions => 200, :total_reach => 200, :potential_reach => 200,
      :total_prints_per_anno => 200, :total_prints => 200, :total_clicks_anno => 200, :fans_through_anno => 30, :agency_investment => 140.5,
      :new_stock_investment => 1600.0, :anno_investment => 2300.5, :ctr_anno => 0.097, :cpm_anno => 0.08, :cpc_anno => 0.2,
      :ranking_world => 100, :ranking_espana => 10, :social_network_id => 1
    }
  end

  describe "# index" do
    it "assigns @facebook_data has the correct data" do
      FacebookDatum.create! valid_attributes2
      FacebookDatum.create! valid_attributes
      facebook_datum = FacebookDatum.find(:all, :order => "start_date ASC")
      get :index, :idc => 1, :locale => :es, :opcion => 1, :id_social => 1
      assigns(:facebook_data).should eq(facebook_datum)
    end

    it "gets @facebook_data in a date range" do
      facebook_data = FacebookDatum.create! valid_attributes
      get :index, :locale => :es, :idc => facebook_data.client_id, :id_social => 1, :opcion => 2, :start_date => "01-08-2012", :end_date => "15-08-2012"
      assigns(:facebook_data).should eq([facebook_data])
    end

  end

  describe "#new" do
    let(:facebook_data) {{ "data" => [ { "values" => [ {"value" => 1}, {"value" => 2}, {"value" => 3}]} ]}}
    it "assigns a new facebook_datum as @facebook_datum" do
      get :new, :idc => 1, :opcion => 2, :id_social => 1, :locale => :es
      assigns(:facebook_datum).should be_a_new(FacebookDatum)
    end

    it "new facebook data with data from facebook" do
      SocialNetwork.create!(:name => "Test Facebook", :client_id => 1, :object_id => "200903812", :info_social_network_id => 1)
      @controller.stub(:http_get).and_return(facebook_data)
      get :new, :idc => 1, :opcion => 1, :id_social => 1, :locale => :en
      assigns(:facebook)['page_friends_of_fans'].should eq(3)
      assigns(:facebook)['page_fan_removes_unique'].should eq(6)
    end

    it "gets json from http request to facebook" do
      http_request = mock('http_request', :read => 'response')
      SocialNetwork.create!(:name => "Test Facebook", :client_id => 1, :object_id => "200903812", :info_social_network_id => 1)
      @controller.stub(:open).and_return(http_request)
      JSON.should_receive(:parse).any_number_of_times.with('response').and_return(facebook_data)
      get :new, :idc => 1, :opcion => 1, :id_social => 1, :locale => :en, :start_date => Time.now, :end_date=>Time.now, :access_token=>'token'
    end
  end

  describe "# edit" do
    it "assigns the requested facebook_datum as @facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :edit, :locale => :es, :idc => 1, :id_social =>1, :id => facebook_datum.id.to_s
      assigns(:facebook_datum).should eq(facebook_datum)
    end
  end

  describe "# create" do
    context "with valid params" do
      it "creates a new FacebookDatum" do
        expect {
          post :create, :locale => :es, :facebook_datum => valid_attributes
          post :create, :locale => :es, :facebook_datum => valid_attributes2
        }.to change(FacebookDatum, :count).by(2)
      end

      it "assigns a newly created facebook_datum as @facebook_datum" do
        post :create, :locale => :es, :facebook_datum => valid_attributes
        assigns(:facebook_datum).should be_a(FacebookDatum)
        assigns(:facebook_datum).should be_persisted
      end

      it "redirects to the created facebook_datum" do
        post :create, :locale => :es, :facebook_datum => valid_attributes
        response.should redirect_to(facebook_index_path(1,1,1))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved facebook_datum as @facebook_datum" do
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es, :facebook_datum => {:start_date => "01-01-2012", :end_date => "15-01-2012"}
        assigns(:facebook_datum).should be_a_new(FacebookDatum)
      end

      it "re-renders the 'new' template" do
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es, :facebook_datum => {:start_date => "01-01-2012", :end_date => "15-01-2012"}
        response.should render_template("new")
      end
    end
  end

  describe "# update" do
    context "with valid params" do
      it "updates the requested facebook_datum" do
        FacebookDatum.create! valid_attributes2
        facebook_datum = FacebookDatum.create! valid_attributes
        put :update, :locale => :es, :id => facebook_datum.id, :facebook_datum => {'end_date' => "01-01-2011", 'start_date' => "01-02-2011", 'actions' => 100}
        facebook_datum = FacebookDatum.find(facebook_datum.id)
        facebook_datum.start_date.should eq("01-02-2011".to_date)
        facebook_datum.end_date.should eq("01-01-2011".to_date)
        facebook_datum.actions.should eq("100")
      end

      it "assigns the requested facebook_datum as @facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        put :update, :locale => :es, :id => facebook_datum.id, :facebook_datum => valid_attributes
        assigns(:facebook_datum).should eq(facebook_datum)
      end

      it "redirects to the facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        put :update, :locale => :es, :id => facebook_datum.id, :facebook_datum => valid_attributes
        response.should redirect_to(facebook_index_path(1,1,1))
      end
    end

    context "with invalid params" do
      it "assigns the facebook_datum as @facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :locale => :es, :id => facebook_datum.id.to_s, :facebook_datum => {}
        assigns(:facebook_datum).should eq(facebook_datum)
      end

      it "re-renders the 'edit' template" do
        facebook_datum = FacebookDatum.create! valid_attributes
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :locale => :es, :id => facebook_datum.id.to_s, :facebook_datum => {}
        response.should render_template("edit")
      end
    end
  end

  describe "# destroy" do
    it "destroys the requested facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      expect {
        delete :destroy, :locale => :es, :id => facebook_datum.id.to_s
      }.to change(FacebookDatum, :count).by(-1)
    end

    it "redirects to the facebook_data list" do
      facebook_datum = FacebookDatum.create! valid_attributes
      delete :destroy, :locale => :es, :id => facebook_datum.id.to_s
      response.should redirect_to(facebook_index_path(1,1,1))
    end
  end

  describe "#save_comment" do
    it "update a comments of a FacebookComments given a social network" do
      FacebookComment.create!({:social_network_id => 1})
      post :save_comment, :locale => :es, :comment => "Comment Table Test", :id_comment => "table", :social_network => 1
      post :save_comment, :locale => :es, :comment => "Comment Fans Test", :id_comment => "fans", :social_network => 1
      datum_comments = FacebookComment.find_by_social_network_id(1)
      datum_comments.table.should eq("Comment Table Test")
      datum_comments.fans.should eq("Comment Fans Test")
    end
  end

  describe "#callback" do
    it "gets access token from facebook" do
      http_request = mock('http_request', :read => 'access_token=o4piurousfhasdhfoasidhfa23w4q324&others_params')
      URI.should_receive(:escape).with("https://graph.facebook.com/oauth/access_token?client_id=441436639234798&redirect_uri=http://test.host/en/facebook_data/callback/1/1/01-01-2012/15-01-2012/&code=code_from_facebook&client_secret=26df47c99d81ecb606fe2eb59669476d").and_return("http://test.com")
      @controller.stub(:open).and_return(http_request)
      get :callback, :idc => 1, :id_social => 1, :locale => :en, :start_date => "01-01-2012", :end_date => "15-01-2012", :code => "code_from_facebook"
    end
  end

end
