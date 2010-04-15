class Census::DataGroupsController < ApplicationController
  
  def index
    @data_groups = DataGroup.all
  end

  def new
    @data_group = DataGroup.new(params[:data_group])
  end
  
  def create
    @data_group = DataGroup.new(params[:data_group])
    
    if @data_group.save
      flash[:notice] = "Created #{@data_group.name}"
      redirect_to census_admin_path
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
      redirect_to census_admin_path
    else
      render :action => 'edit', :status => :unprocessable_entity
    end
  end
  
  def destroy
    @data_group = DataGroup.find(params[:id])
    @data_group.destroy
    flash[:notice] = "Deleted #{@data_group.name}"
    redirect_to census_admin_path
  end
  
  def sort
    group_positions = params[:data_group].to_a
    DataGroup.all.each_with_index do |group, i|
      group.position = group_positions.index(group.id.to_s) + 1
      group.save
    end
    render :text => 'ok'
  end

end
