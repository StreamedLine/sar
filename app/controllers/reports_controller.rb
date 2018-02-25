class ReportsController < ApplicationController
  def index
  	@flagged = Report.flag 
  end

  def flag
  	Report.delete_all
  	Report.upload(params[:file])
  	redirect_to '/'
  end
end
