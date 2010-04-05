class Census::DataGroupsController < ApplicationController
  
  def index
    @data_groups = DataGroup.all(:order => :position)
  end

  def new
    @data_group = DataGroup.new(params[:data_group])
  end
  
  def create
    @data_group = DataGroup.new(params[:data_group])
    
    if @data_group.save
      flash[:notice] = "Created #{@data_group.name}"
      redirect_to census_data_groups_path
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end
  
  def edit
    @data_group = DataGroup.find(params[:id])
  end
  
  def update
    @data_group = DataGroup.find(params[:id])
    
    if @data_group.update_attributes(params[:data_group])
      flash[:notice] = "Saved #{@data_group.name}"
      redirect_to census_data_groups_path
    else
      render :action => 'edit', :status => :unprocessable_entity
    end
  end
  
  def destroy
    @data_group = DataGroup.find(params[:id])
    @data_group.destroy
    flash[:notice] = "Deleted #{@data_group.name}"
    redirect_to census_data_groups_path
  end

end
