class BenchmarkDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(BenchmarkComment, params[:id_social])
      BenchmarkComment.new(:social_network_id => params[:id_social].to_i).save! 
    end
    @benchmark = select_benchmark_data
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
    data_of_competitor = BenchmarkDatum.find(params[:id])
    benchmark_competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:social_network_id]).order("name ASC")
    benchmark_competitors.each do |competitor|
      values = {start_date: params[:start_date], end_date: params[:end_date]}.merge(params[competitor.id.to_s.to_sym])
      datum = BenchmarkDatum.find_by_benchmark_competitor_id_and_start_date_and_end_date(competitor.id, data_of_competitor.start_date, data_of_competitor.end_date)
      datum.update_attributes(values)
    end
    respond_to do |format|
      format.html { redirect_to benchmark_index_path(params[:client_id], 1, params[:social_network_id]), notice: 'La informacion ha sido actualizada exitosamente.' }
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
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    respond_to do | format |
      format.json { render json: message.to_json }
    end
  end

  private

  def select_benchmark_data
    benchmark_data = { "x_axis" => [] }
    competitors = BenchmarkCompetitor.where('social_network_id = ?', params[:id_social]).order("name ASC")
    benchmark_data['competitors'] = competitors.map(&:name)
    competitors.each do |competitor|
      competitor_data = data_of_competitor(competitor.id)
      benchmark_data['dates'] ||= competitor_data.collect { |data| "#{data.start_date.strftime("%d %b")} - #{data.end_date.strftime("%d %b")}"}
      benchmark_data['ids'] ||= competitor_data.map(&:id)
      benchmark_data[competitor.name] = []
      competitor_data.each do |datum|
        benchmark_data['x_axis'].concat(x_axis_array(datum.start_date, datum.end_date))
        benchmark_keys.each do |key|
          benchmark_data[competitor.name].push(datum[key])
        end
      end
      start_date = competitor_data.first.start_date
      end_date = competitor_data.first.end_date
    end
    return benchmark_data
  end

  def data_of_competitor(id)
    if get_data_in_range? 
      data = BenchmarkDatum.where('start_date = ? and end_date = ? and benchmark_competitor_id = ?', params[:start_date].to_date, params[:end_date].to_date, id).order("start_date ASC") 
    else
      data = BenchmarkDatum.where(:benchmark_competitor_id => id).order("start_date ASC")
    end
  end

  def get_data_in_range?
    (params.has_key?(:start_date) && params.has_key?(:end_date)) ? (true) : (false)
  end

  def benchmark_keys
    ['blogs',
      'forums',
      'videos',
      'twitter',
      'facebook',
      'others'
    ]
  end

  def x_axis_array(start_date, end_date)
    ['Blogs', 
      "Foros   #{start_date.strftime("%d %b")}",
      "Videos   al",
      "Twitter   #{end_date.strftime("%d %b")}",
      "Facebook",
      "Otros"
    ]
  end

end
