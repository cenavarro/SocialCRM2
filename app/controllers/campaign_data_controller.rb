# encoding: utf-8
class CampaignDataController < ApplicationController
  before_filter :authenticate_user!

  def index
    if existParamIdClient?
      @rows_campaign = RowsCampaign.where('social_network_id = ?', params[:id_social].to_i)
      respond_to do |format|
        format.html
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @rows_campaign = RowsCampaign.where('social_network_id = ?', params[:id_social].to_i)
    respond_to do |format|
      format.html
    end
  end

  def edit
    @rows_campaign = RowsCampaign.where('social_network_id = ?', params[:id_social].to_i)
    @row = RowDatum.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def create
    params.each do |key,value|
      if key.start_with?('criteria_')
        new_row_data = RowDatum.new(:start_date => params[:start_date], :end_date => params[:end_date], :value => value, :rows_campaign_id => key[9,key.length])
        new_row_data.save!
      end
    end
    respond_to do |format|
      format.html { redirect_to campaign_index_path(params[:idc],1,params[:id_social]), notice: "La informacion se ha ingresdo de forma exitosa!"}
    end
  end

  def update
    params.each do |key,value|
      if key.start_with?('criteria_')
        row = RowDatum.find(key[9, key.length].to_i)
        row.start_date = params[:start_date].to_date
        row.end_date = params[:end_date].to_date
        row.value = value
        row.save!
      end
    end
    respond_to do |format|
      format.html { redirect_to campaign_index_path(params[:idc],1,params[:id_social]), notice: "La informacion se ha ingresdo de forma exitosa!"}
    end
  end

  def destroy
    @rows_campaign = RowsCampaign.where('social_network_id = ?', params[:id_social].to_i)
    data = RowDatum.find(params[:id])
    rows_data  = RowDatum.where('start_date >= ? and end_date <= ?', data.start_date, data.end_date) 
    rows_data.destroy_all
    respond_to do |format|
      format.html { redirect_to campaign_index_path(params[:idc],1,params[:id_social]), :notice => "La informacion ha sido borrada exitosamente!"}
    end
  end

  def save_comment
    campaign = CampaignComment.find_by_social_network_id(params[:social_network].to_i)
    campaign.table = params[:comment]
    campaign.save! ? (msg = "Comentario Guardado!") : (msg = "El comentario no se pudo guardar!")
    render :json => msg.to_json
  end

  def existParamIdClient?
    params.has_key?(:idc) ? (return true) : (return false)
  end

end
