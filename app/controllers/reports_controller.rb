class ReportsController < ApplicationController
  def index
  	@flagged = Report.flag 
  	@flagged.push("No records flagged") if @flagged.count == 0
  end

  def flag
  	Report.delete_all
  	Report.upload(params[:file])
  	redirect_to '/'
  end
end
