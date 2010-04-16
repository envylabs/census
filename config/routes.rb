ActionController::Routing::Routes.draw do |map|

  map.namespace :census do |census|
    census.resources :data_groups,
                     :except => [:index, :show],
                     :collection => {:sort => :put}
    
    census.admin 'admin', :controller => 'data_groups', :action => 'index'
  end

end
