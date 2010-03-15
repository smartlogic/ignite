ActionController::Routing::Routes.draw do |map|
  map.resources :articles, :collection => {:post_comment => :post, :news => :get, :top_news => :get, :about => :get, :affiliates => :get}, :only => [:index, :news, :show, :post_comment]
  
  map.resources :events, :collection => {:past => :get, :post_comment => :post}, :only => [:index, :show, :past, :post_comment] do |event|
    event.resources :speakers, :only => [:index, :show]
  end
  
  map.resources :organizers, :only => [:index, :show]
  map.resources :speakers, :only => [:index, :show], 
    :collection => {:post_comment => :post, :proposals => :get}
  map.resources :proposals, :only => [:new, :create], :collection => {:post_comment => :post}

  map.namespace(:admin) do |admin|
    admin.resources :admins
    admin.resources :articles
    admin.resources :comments, :only => [:index, :destroy]
    admin.resources :events, :member => {:set_feature => :put}
    admin.resources :organizers
    admin.resources :speakers, 
      :except => [:new, :create],
      :member => {:archive => :put, :unarchive => :put, :reconsider => :put, :choose => :put}, 
      :collection => {:csv => :get}
    admin.resources :ignites, :has_many => :events
    admin.resources :sponsors
  end

  map.update_admin_speaker_event_select '/admin/speakers/update_event_select', :controller => 'admin/speakers', :action => 'update_event_select'

  map.about '/about', :controller => 'articles', :action => 'about'
  map.friends '/friends', :controller => 'articles', :action => 'friends'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'admin/admins', :action => 'create'
  map.signup '/signup', :controller => 'admin/admins', :action => 'new'
  map.sponsor_ignite '/sponsor_ignite', :controller => 'articles', :action => 'sponsor_ignite'
  map.news '/news', :controller => 'articles', :action => 'news'

  map.admin '/admin', :controller => 'admin/speakers'
  map.root :controller => 'articles', :action => 'top_news'

  map.resource :session
end
