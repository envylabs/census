ActionController::Routing::Routes.draw do |map|

  map.namespace :census do |census|
    census.resources :data_groups, :except => [:show]
  end

end
