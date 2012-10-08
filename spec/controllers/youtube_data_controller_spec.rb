require 'spec_helper'

describe YoutubeDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {:client_id => 1, :start_date => "01-01-2012".to_date, :end_date => "15-01-2012".to_date, :social_network_id => 1, :new_subscriber => 0, :total_subscriber => 1, :total_video_views => 1, :inserted_player => 1, :mobile_devise => 1, :youtube_search => 1, :youtube_suggestion => 1, :youtube_page => 1, :external_web_site => 1, :google_search => 1, :youtube_others => 1, :youtube_subscriptions => 1, :youtube_ads => 1, :investment_agency => 1, :investment_actions => 1, :investment_anno => 1}
  end

  describe "#index" do
    it "assigns all youtube_data as @youtube_data without date range" do
      youtube_datum = YoutubeDatum.create! valid_attributes
      get :index, :idc => 1, :opcion => 1, :id_social => 1, :locale => :es
      assigns(:youtube_datum).should eq([youtube_datum])
    end
    it "assigns all youtube_data as @youtube_data with date range" do
      youtube_datum = YoutubeDatum.create! valid_attributes
      get :index, :idc => 1, :opcion => 2, :id_social => 1, :start_date => "01-01-2012", :end_date => "15-01-2012", :locale => :es
      assigns(:youtube_datum).should eq([youtube_datum])
    end
  end

  describe "#new" do
    it "assigns a new youtube_datum as @youtube_datum" do
      get :new, :idc => 1, :opcion => 1, :id_social => 1, :locale => :es
      assigns(:youtube_datum).should be_a_new(YoutubeDatum)
    end
  end

  describe "#edit" do
    it "assigns the requested youtube_datum as @youtube_datum" do
      youtube_datum = YoutubeDatum.create! valid_attributes
      get :edit, :idc => 1, :id_social => 1, :locale => :es , :id => youtube_datum.to_param
      assigns(:youtube_datum).should eq(youtube_datum)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new YoutubeDatum" do
        expect {
          post :create, :youtube_datum => valid_attributes, :locale => :es
        }.to change(YoutubeDatum, :count).by(1)
      end

      it "assigns a newly created youtube_datum as @youtube_datum" do
        post :create, :youtube_datum => valid_attributes, :locale => :es
        assigns(:youtube_datum).should be_a(YoutubeDatum)
        assigns(:youtube_datum).should be_persisted
      end

      it "redirects to the created youtube_datum" do
        post :create, :youtube_datum => valid_attributes, :locale => :es
        response.should redirect_to(youtube_index_path(1, 1, 1))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved youtube_datum as @youtube_datum" do
        YoutubeDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es
        assigns(:youtube_datum).should be_a_new(YoutubeDatum)
      end

      it "re-renders the 'new' template" do
        YoutubeDatum.any_instance.stub(:save).and_return(false)
        post :create, :locale => :es
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested youtube_datum" do
        youtube_datum = YoutubeDatum.create! valid_attributes
        # Assuming there are no other youtube_data in the database, this
        # specifies that the YoutubeDatum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        YoutubeDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => youtube_datum.to_param, :youtube_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested youtube_datum as @youtube_datum" do
        youtube_datum = YoutubeDatum.create! valid_attributes
        put :update, {:id => youtube_datum.to_param, :youtube_datum => valid_attributes}, valid_session
        assigns(:youtube_datum).should eq(youtube_datum)
      end

      it "redirects to the youtube_datum" do
        youtube_datum = YoutubeDatum.create! valid_attributes
        put :update, {:id => youtube_datum.to_param, :youtube_datum => valid_attributes}, valid_session
        response.should redirect_to(youtube_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the youtube_datum as @youtube_datum" do
        youtube_datum = YoutubeDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        YoutubeDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => youtube_datum.to_param, :youtube_datum => {}}, valid_session
        assigns(:youtube_datum).should eq(youtube_datum)
      end

      it "re-renders the 'edit' template" do
        youtube_datum = YoutubeDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        YoutubeDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => youtube_datum.to_param, :youtube_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested youtube_datum" do
      youtube_datum = YoutubeDatum.create! valid_attributes
      expect {
        delete :destroy, :id => youtube_datum.to_param, :locale => :es
      }.to change(YoutubeDatum, :count).by(-1)
    end

    it "redirects to the youtube_data index" do
      youtube_datum = YoutubeDatum.create! valid_attributes
      delete :destroy, :id => youtube_datum.to_param
      response.should redirect_to(youtube_index_path(1,1,1))
    end
  end

  describe "#save_comment" do
    it "table comment saved" do
      YoutubeComment.new(:social_network_id => 1).save!
      post :save_comment, :locale => :es, :social_network => 1, :id_comment => 1, :comment => "Esto es una prueba"
      comment = YoutubeComment.where(:social_network_id => 1)[0]
      comment.table.should eq("Esto es una prueba")
    end
    it "community comment saved" do
      YoutubeComment.new(:social_network_id => 1).save!
      post :save_comment, :locale => :es, :social_network => 1, :id_comment => 2, :comment => "Esto es una prueba"
      comment = YoutubeComment.where(:social_network_id => 1)[0]
      comment.community.should eq("Esto es una prueba")
    end
    it "interaction comment saved" do
      YoutubeComment.new(:social_network_id => 1).save!
      post :save_comment, :locale => :es, :social_network => 1, :id_comment => 3, :comment => "Esto es una prueba"
      comment = YoutubeComment.where(:social_network_id => 1)[0]
      comment.interaction.should eq("Esto es una prueba")
    end
    it "interaction comment saved" do
      YoutubeComment.new(:social_network_id => 1).save!
      YoutubeComment.any_instance.stub(:save).and_return(false)
      post :save_comment, :locale => :es, :social_network => 1, :id_comment => 3, :comment => "Esto es una prueba"
      comment = YoutubeComment.where(:social_network_id => 1)[0]
      comment.interaction.should be_nil
    end
  end

end
