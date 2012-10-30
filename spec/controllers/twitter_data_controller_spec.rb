require 'spec_helper'

describe TwitterDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    { 
      :client_id => 1, :global_goal => "Objetivo Followers Text", :new_followers => 10, :total_followers => 10, :goal_followers => 10,
      :amount_tweets => 10, :total_tweets => 10, :total_mentions => 10, :ret_tweets => 10, :total_clicks => 10,
      :total_interactions => 10, :agency_investment => 10.5, :cost_follower => 0.1, :start_date => "2012/08/01".to_date, :end_date => "2012/08/15".to_date
    }
  end

  describe "# index" do
    it "assigns all twitter_data as @twitter_data" do
      twitter_datum = TwitterDatum.create! valid_attributes
      get :index, :idc => twitter_datum.client_id
      assigns(:twitter_data).should eq([twitter_datum])
    end

    it "shows a twitter_data in a date range" do
      twitter_datum = TwitterDatum.create! valid_attributes
      get :index, :idc => twitter_datum.client_id, :opcion => 2, :ff => {"ff(1i)" => 2012, "ff(2i)" => 8, "ff(3i)" => 15},:fi => {"fi(3i)"=> 1, "fi(2i)"=> 8, "fi(1i)"=> 2012} 
      assigns(:twitter_data).should eq([twitter_datum])
    end
  end

  describe "# new" do
    it "assigns a new twitter_datum as @twitter_datum" do
      get :new, :idc => 1, :opcion => 2
      assigns(:twitter_datum).should be_a_new(TwitterDatum)
    end
  end

  describe "# edit" do
    it "assigns the requested twitter_datum as @twitter_datum" do
      twitter_datum = TwitterDatum.create! valid_attributes
      get :edit, {:id => twitter_datum.to_param}
      assigns(:twitter_datum).should eq(twitter_datum)
    end
  end

  describe "# create" do
    context "with valid params" do
      it "creates a new TwitterDatum" do
        expect {
          post :create, {:twitter_datum => valid_attributes}
        }.to change(TwitterDatum, :count).by(1)
      end

      it "assigns a newly created twitter_datum as @twitter_datum" do
        post :create, {:twitter_datum => valid_attributes}
        assigns(:twitter_datum).should be_a(TwitterDatum)
        assigns(:twitter_datum).should be_persisted
      end

      it "redirects to the created twitter_datum" do
        post :create, {:twitter_datum => valid_attributes}
        response.should redirect_to(%{/twitter_data/#{TwitterDatum.last.client_id}/1})
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved twitter_datum as @twitter_datum" do
        TwitterDatum.any_instance.stub(:save).and_return(false)
        post :create, {:twitter_datum => {}}
        assigns(:twitter_datum).should be_a_new(TwitterDatum)
      end

      it "re-renders the 'new' template" do
        TwitterDatum.any_instance.stub(:save).and_return(false)
        post :create, {:twitter_datum => {}}
        response.should render_template("new")
      end
    end
  end

  describe "# update" do
    context "with valid params" do
      it "updates the requested twitter_datum" do
        twitter_datum = TwitterDatum.create! valid_attributes
        TwitterDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => twitter_datum.to_param, :twitter_datum => {'these' => 'params'}}
      end

      it "assigns the requested twitter_datum as @twitter_datum" do
        twitter_datum = TwitterDatum.create! valid_attributes
        put :update, {:id => twitter_datum.to_param, :twitter_datum => valid_attributes}
        assigns(:twitter_datum).should eq(twitter_datum)
      end

      it "redirects to the twitter_datum" do
        twitter_datum = TwitterDatum.create! valid_attributes
        put :update, {:id => twitter_datum.to_param, :twitter_datum => valid_attributes}
        response.should redirect_to(%{/twitter_data/#{TwitterDatum.last.client_id}/1})
      end
    end

    context "with invalid params" do
      it "assigns the twitter_datum as @twitter_datum" do
        twitter_datum = TwitterDatum.create! valid_attributes
        TwitterDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => twitter_datum.to_param, :twitter_datum => {}}
        assigns(:twitter_datum).should eq(twitter_datum)
      end

      it "re-renders the 'edit' template" do
        twitter_datum = TwitterDatum.create! valid_attributes
        TwitterDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => twitter_datum.to_param, :twitter_datum => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "# destroy" do
    it "destroys the requested twitter_datum" do
      twitter_datum = TwitterDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => twitter_datum.to_param}
      }.to change(TwitterDatum, :count).by(-1)
    end

    it "redirects to the twitter_data list" do
      twitter_datum = TwitterDatum.create! valid_attributes
      delete :destroy, {:id => twitter_datum.to_param}
      response.should redirect_to(%{/twitter_data/#{twitter_datum.client_id}/1})
    end
  end

end
