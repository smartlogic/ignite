ActionController::Routing::Routes.draw do |map|
  
  map.resources :articles, :collection => {:post_comment => :post, :news => :get, :top_news => :get, :about => :get, :affiliates => :get}, :only => [:index, :news, :show, :post_comment]
  
  map.resources :events, :collection => {:past => :get, :post_comment => :post}, :only => [:index, :show, :past, :post_comment] do |event|
    event.resources :speakers, :only => [:index, :show]
  end
  
  map.resources :organizers, :only => [:index, :show]
  map.resources :speakers, :only => [:index, :show], :collection => {:post_comment => :post}
  map.resources :proposals, :only => [:index, :show, :new, :create], :collection => {:post_comment => :post}

  map.namespace(:admin) do |admin|
    admin.resources :admins
    admin.resources :articles
    admin.resources :comments, :only => [:index, :destroy]
    admin.resources :events, :member => {:set_feature => :put}
    admin.resources :organizer_roles
    admin.resources :organizers
    admin.resources :speakers, :collection => {:archive => :delete, :proposals => :get, :csv => :get}
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

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
