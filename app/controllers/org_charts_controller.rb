class OrgChartsController < ApplicationController
  
  def new
    @org_chart = OrgChart.new(params)
  end

  def create
    @org_chart = OrgChart.new(params)
    render :layout => false
  end

end
