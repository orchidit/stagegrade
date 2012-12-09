ActionController::Routing::Routes.draw do |map|
  map.resources :email_list, :controller => :emails,
    :collection => { :subscribe => :get, :unsubscribe => :get, :do_subscribe => :post, :do_unsubscribe => :post }

  map.resources :user_reviews, :only => [ :index, :edit, :update, :destroy ],
      :member => { :vote_up => :post, :vote_down => :post, :undo_vote => :delete } do |ur|
    ur.resources :reports, :only => [ :new, :create ], :collection => { :spam => :post }
  end

  map.auto_complete ':controller/:action',
                    :requirements => { :action => /auto_complete_for_\S+/ },
                    :conditions => { :method => :get }

  map.production_archives 'productions/archives', :controller => 'productions', :action => 'archives'
  map.resource :account, :controller => "users", :member => { :share => :get }
  map.resource :facebook, :controller => "facebook", :member => {
    :associate => :get,
    :create_session => :post,
    :create_user => :post,
    :link_user => :post,
    :unlink_user => :post
  }
  map.resources :posts
  map.resources :reviewers
  map.resources :participants
  map.resources :productions do |prod|
    prod.resources :user_reviews, :only => [ :new, :create ]
  end
  map.resources :roles
  map.resource :user_session, :member => { :fb_login => :post }
  map.resources :users, :member => { :fb_link => :post, :fb_unlink => :post }
  map.resources :publications
  map.resources :theatres
  map.resources :critics
  map.resources :reviews, :only => :show # TODO: Temporary until links are set on reviews.

  map.namespace :admin do |admin|
    admin.resources :emails
    admin.resources :panels, :member => { :move_up => :post, :move_down => :post }
    admin.resources :pages
    admin.resources :posts
    admin.resources :quotes
    admin.resources :relationship_types
    admin.resources :relationships
    admin.resources :participants
    admin.resources :productions
    admin.resources :roles
    admin.users_email_list 'users/email_list', :controller => 'users', :action => 'email_list', :format => 'text'
    admin.resources :users
    admin.resources :publications
    admin.resources :theatres
    admin.resources :critics
    admin.resources :plays
    admin.resources :reviews
    admin.resources :user_reviews
    admin.resources :reports, :member => { :review => :post, :unreview => :post }
    admin.resources :access_codes
  end

  map.on_stage_now 'on_stage_now', :controller => 'welcome', :action => 'on_stage_now'
  map.feed 'feed', :controller => 'welcome', :action => 'index', :format => 'atom'
  map.feedburner_feed 'feedburner_feed', :controller => 'welcome', :action => 'index', :format => 'atom'
  map.fb 'fb', :controller => 'welcome', :action => 'fb', :format => 'atom'
  map.connect 'admin/index', :controller => 'admin/index', :action => 'index'
  map.admin_index 'admin', :controller => 'admin/index', :action => 'index'

  map.connect '/:slug.html', :controller => :pages, :action => :show
  map.root :controller => 'welcome'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

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
  # consider removing or commenting them out if you're using named routes and resources.

end
