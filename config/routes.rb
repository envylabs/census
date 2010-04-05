ActionController::Routing::Routes.draw do |map|

  map.namespace :census do |census|
    census.resources :data_groups, :except => [:index, :show]
    census.admin 'admin', :controller => 'data_groups', :action => 'index'
  end

end
