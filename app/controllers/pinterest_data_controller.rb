class PinterestDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(PinterestComment, params[:id_social])
      PinterestComment.create(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @pinterest_datum = PinterestDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @pinterest_datum = PinterestDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end
    @pinterest = select_chart_data
    @report = Axlsx::Package.new
    FacebookDatum.generate_excel(@report, 2, "01-01-2012", "31-12-2012")
    BlogDatum.generate_excel(@report, 4, "01-01-2012", "31-12-2012")
    FlickrDatum.generate_excel(@report, 1, "01-01-2012", "31-12-2012")
    FoursquareDatum.generate_excel(@report, 6, "01-01-2012", "31-12-2012")
    GooglePlusDatum.generate_excel(@report, 7, "01-01-2012", "31-12-2012")
    LinkedinDatum.generate_excel(@report, 8, "01-01-2012", "08-11-2012")
    @report.serialize('reporte.xlsx')
  end

  def new
    @pinterest_datum = PinterestDatum.new
  end

  def edit
    @pinterest_datum = PinterestDatum.find(params[:id])
  end

  def create
    @pinterest_datum = PinterestDatum.new(params[:pinterest_datum])
    respond_to do |format|
      if @pinterest_datum.save
        @pinterest_datum.new_followers = PinterestDatum.get_new_followers(@pinterest_datum)
        @pinterest_datum.save!
        format.html { redirect_to pinterest_index_path(@pinterest_datum.client_id,1,@pinterest_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @pinterest_datum = PinterestDatum.find(params[:id])

    respond_to do |format|
      if @pinterest_datum.update_attributes(params[:pinterest_datum])
        @pinterest_datum.new_followers = PinterestDatum.get_new_followers(@pinterest_datum)
        @pinterest_datum.save!
        format.html { redirect_to pinterest_index_path(@pinterest_datum.client_id,1,@pinterest_datum.social_network_id), notice: 'La informacion se ha actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @pinterest_datum = PinterestDatum.find(params[:id])
    client_id = @pinterest_datum.client_id
    social_id = @pinterest_datum.social_network_id
    @pinterest_datum.destroy

    respond_to do |format|
      format.html { redirect_to pinterest_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  def save_comment
    comment = PinterestComment.where(:social_network_id => params[:social_network].to_i)[0]
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @pinterest_datum.collect{|pd| "#{pd.start_date.strftime('%d %b')} - #{pd.end_date.strftime('%d %b')}"}
    pinterest_keys.each do |key|
      chart_data[key] = @pinterest_datum.map(&:"#{key}")
    end
    chart_data['total_investment'] = @pinterest_datum.collect{|pd| PinterestDatum.get_total_investment(pd)}
    return chart_data
  end

  def pinterest_keys
    ['new_followers',
      'total_followers',
      'boards',
      'pins',
      'liked',
      'repin',
      'comments',
      'community_boards'
    ]
  end

end
