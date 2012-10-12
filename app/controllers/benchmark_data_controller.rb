class BenchmarkDataController < ApplicationController
  before_filter :authenticate_user!

  def create_chart_data

  end

  def index
    if !has_comments_table?(BenchmarkComment, params[:id_social])
      BenchmarkComment.new(:social_network_id => params[:id_social].to_i).save! 
    end
    @benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    create_chart_data
    respond_to do |format|
      format.html
    end
  end

  def new
    @benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    respond_to do |format|
      format.html
    end
  end

  def edit
    @benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    data = BenchmarkDatum.find(params[:id])
    @start_date = data.start_date.strftime("%d-%m-%Y")
    @end_date = data.end_date.strftime("%d-%m-%Y")
  end

  def create
    benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:social_network_id]).order("name ASC")
    benchmark_competitors.each do |competitor|
      value = params[competitor.id.to_s.to_sym]
      BenchmarkDatum.create!({benchmark_competitor_id: competitor.id.to_i, start_date: Date.parse(params[:start_date]), end_date: params[:end_date]}.merge(value))
    end
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(params[:client_id],1,params[:social_network_id]), notice: 'La informacion se ha ingresado exitosamente.' }
    end
  end

  def update
    benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:social_network_id]).order("name ASC")
    benchmark_competitors.each do |competitor|
      values = {start_date: params[:start_date], end_date: params[:end_date]}.merge(params[competitor.id.to_s.to_sym])
      datum = BenchmarkDatum.find_by_benchmark_competitor_id(competitor.id)
      datum.update_attributes(values)
    end
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(params[:client_id],1,params[:social_network_id]), notice: 'La informacion ha sido actualizada exitosamente.' }
    end
  end

  def destroy
    data = BenchmarkDatum.find(params[:id])
    social_network_id = BenchmarkCompetitor.find(data.benchmark_competitor_id).social_network_id
    client_id = SocialNetwork.find(social_network_id).client_id
    benchmark_datum = BenchmarkDatum.where('start_date = ? and end_date = ?', data.start_date, data.end_date) 
    benchmark_datum.delete_all
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(client_id,1,social_network_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  def save_comment
    comment = BenchmarkComment.find_by_social_network_id(params[:social_network].to_i)
    message = "El comentario no se pudo guardar!"
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = "Comentario Guardado!"
    end
    respond_to do | format |
      format.json { render json: message.to_json }
    end
  end

end
