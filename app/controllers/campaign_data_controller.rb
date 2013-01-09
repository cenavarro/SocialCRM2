# encoding: utf-8
class CampaignDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    create_campaign_data
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

  private 

  def create_campaign_data
    @campaign_data = { "dates" => [], "data" => [] }
    row_data = []
    rows_campaign = RowsCampaign.where('social_network_id = ?', params[:id_social].to_i)
    rows_campaign.each do |row|
      row_data = select_row_data(row.id, params[:start_date], params[:end_date])
      values = row_data.map(&:value)
      @campaign_data['data'] << {"#{row.name}" => values}
    end
    @campaign_data['ids'] = row_data.map(&:id)
    row_data.collect{ |datum| @campaign_data['dates'] << datum.start_date.strftime("%d %b ") + datum.end_date.strftime("- %d %b")}.join(', ')
  end

  def select_row_data(id, start_date, end_date)
    if data_in_range?(start_date, end_date)
      row_data = RowDatum.where('rows_campaign_id = ? and start_date >= ? and end_date <= ?', id, start_date.to_date, end_date.to_date).order("start_date ASC")
    else
      row_data = RowDatum.where('rows_campaign_id = ?', id).order("start_date ASC")
    end
  end

  def data_in_range?(start_date, end_date)
    (start_date && end_date) ? (true) : (false)
  end

end
