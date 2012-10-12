class PinterestDataController < ApplicationController
  before_filter :authenticate_user!

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

    create_chart_data

    respond_to do |format|
      format.html
    end
  end

  def new
    @pinterest_datum = PinterestDatum.new

    respond_to do |format|
      format.html
    end
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

  def create_chart_data
    @dates = @pinterest_datum.collect { |ld| "'" + ld.start_date.mday().to_s + " " + ld.start_date.strftime('%b') + "-" + ld.end_date.mday().to_s + " " + ld.end_date.strftime('%b') + "'" }.join(', ')
    @new_followers = @pinterest_datum.collect(&:new_followers).join(', ')
    @total_followers = @pinterest_datum.collect(&:total_followers).join(', ')
    @boards = @pinterest_datum.collect(&:boards).join(', ')
    @pins = @pinterest_datum.collect(&:pins).join(', ')
    @liked = @pinterest_datum.collect(&:liked).join(', ')
    @repin = @pinterest_datum.collect(&:repin).join(', ')
    @comment = @pinterest_datum.collect(&:comments).join(', ')
    @community_boards = @pinterest_datum.collect(&:community_boards).join(', ')
    @total_investment = @pinterest_datum.collect{ |pd| PinterestDatum.get_total_investment(pd) }.join(', ')
  end

end
