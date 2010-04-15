ActionController::Routing::Routes.draw do |map|

  map.namespace :census do |census|
    census.resources :data_groups,
                     :except => [:index, :show],
                     :collection => {:sort => :put} do |group|
      group.resources :questions,
                      :only => [],
                      :collection => {:sort => :put} do |question|
        question.resources :choices,
                           :only => [],
                           :collection => {:sort => :put}
      end
    end
    
    census.admin 'admin', :controller => 'data_groups', :action => 'index'
  end

end
