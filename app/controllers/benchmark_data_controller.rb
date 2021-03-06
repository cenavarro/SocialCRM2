class BenchmarkDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    @benchmark = select_benchmark_data
  end

  def new
    @benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    @benchmark_columns = BenchmarkColumn.where('social_network_id = ?', params[:id_social]).order("id ASC")
  end

  def edit
    @benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    @benchmark_columns = BenchmarkColumn.where('social_network_id = ?', params[:id_social]).order("id ASC")
    selected_data = BenchmarkDatum.find(params[:id])
    @start_date = selected_data.start_date.strftime("%d-%m-%Y")
    @end_date = selected_data.end_date.strftime("%d-%m-%Y")
  end

  def create
    benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:social_network_id]).order("id ASC")
    benchmark_competitors.each do |competitor|
      data_of_competitor = params["column_#{competitor.id}"].collect{|k,v| v.to_i}
      BenchmarkDatum.create!({benchmark_competitor_id: competitor.id, start_date: params[:start_date], end_date: params[:end_date], values: data_of_competitor.to_s})
    end
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(params[:client_id], 1, params[:social_network_id]), notice: 'La informacion se ha ingresado exitosamente.' }
    end
  end

  def update
    old_data = BenchmarkDatum.find(params[:id])
    benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:social_network_id]).order("id ASC")
    benchmark_competitors.each do |competitor|
      data_of_competitor = params["column_#{competitor.id}"].collect{|k,v| v.to_i}
      new_data = {start_date: params[:start_date], end_date: params[:end_date], values: data_of_competitor.to_s}
      datum = BenchmarkDatum.find_by_benchmark_competitor_id_and_start_date_and_end_date(competitor.id, old_data.start_date, old_data.end_date)
      datum.update_attributes(new_data)
    end
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(params[:client_id], 1, params[:social_network_id]), notice: 'La informacion ha sido actualizada exitosamente.' }
    end
  end

  def destroy
    data_to_delete = BenchmarkDatum.find(params[:id])
    social_network_id = BenchmarkCompetitor.find(data_to_delete.benchmark_competitor_id).social_network_id
    client_id = SocialNetwork.find(social_network_id).client_id
    benchmark_datum = BenchmarkDatum.where('start_date = ? and end_date = ?', data_to_delete.start_date, data_to_delete.end_date) 
    benchmark_datum.delete_all
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(client_id, 1, social_network_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  private

  def competitors
    BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
  end

  def columns
    BenchmarkColumn.where('social_network_id = ?', params[:id_social]).order("id ASC")
  end

  def benchmark_data
    @benchmark_data ||= {
      "x_axis" => [],
      "competitors" => competitors.map(&:name),
      "dates" => dates,
      "ids" => ids, 
      "columns" => columns.map(&:name)
    }
  end

  def dates
    !competitors.empty? ? competitors.first.benchmark_data.where(@where_conditions).order("start_date ASC").collect{ |datum| "#{datum.start_date.strftime("%d %b")} - #{datum.end_date.strftime("%d %b")}"} : []
  end

  def ids
    !competitors.empty? ? competitors.first.benchmark_data.where(@where_conditions).order("start_date ASC").map(&:id) : []
  end

  def x_axis_for_chart
    benchmark_data['dates'].each do |date|
      benchmark_data['x_axis'].concat(x_axis(date[0..5], date[9..date.size]))
    end
  end

  def build_data_of competitor
    competitor_data = competitor.benchmark_data.where(@where_conditions).order("start_date ASC")
    benchmark_data[competitor.name] = []
    competitor_data.each do |datum|
      benchmark_data[competitor.name].push(datum.values)
    end
  end

  def select_benchmark_data
    where_conditions.concat("start_date >= '#{params[:start_date].to_date}' and end_date <= '#{params[:end_date].to_date}'") if get_data_from_range_date?
    competitors.each do |competitor|
      build_data_of competitor
    end
    x_axis_for_chart
    benchmark_data
  end

  def x_axis start_date, end_date
    columns.collect{|column| "#{column.name}<br><br>#{start_date} - #{end_date}"}
  end

  def where_conditions
    @where_conditions ||= ""
  end

end
