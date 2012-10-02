module ApplicationHelper
  def get_start_date
    Date.new(Time.now.strftime('%Y').to_i,Time.now.strftime('%m').to_i,1).strftime('%d-%m-%Y')
  end

  def get_end_date
    Date.new(Time.now.strftime('%Y').to_i,Time.now.strftime('%m').to_i,-1).strftime('%d-%m-%Y')
  end
end
