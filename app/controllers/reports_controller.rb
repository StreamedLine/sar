class ReportsController < ApplicationController
  def index
  	@flagged = Report.flag 
  end

  def flag
  	Report.delete_all
  	flash[:notice] = Report.upload(params[:file])
  	redirect_to '/'
  end

  def clear
  	Report.delete_all
  	flash[:success] = "File successfully cleared"
  	redirect_to '/'
  end
end
