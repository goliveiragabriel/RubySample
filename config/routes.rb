Bemcasado::Application.routes.draw do

  # http://stackoverflow.com/questions/4046960/how-to-redirect-without-www-using-rails-3-rack
  constraints(:host => /^bemcasados.art.br/) do
    match '(*any)' => redirect { |p, req| req.url.sub('//', '//www.') }
  end

  resources :proposals do
    get 'vendors', :on => :collection 
  end



  match "fornecedores/orcamento" => 'proposals#new'
  resources :achievements

  get "user_merits_info/update_closed"

  resources :track_dresses

  get "banners/index"

  get "banners/show/"
  
  #match 'fornecedores/banners/:vendor_id', :controller => 'banners', :action => 'show', :constraints => {:method => 'OPTIONS'}
  match "fornecedores/banners/:vendor_id" => 'banners#show', :as => :banners_fornecedor, :via => ['OPTIONS','GET','POST']

  resources :appointments

  resources :dresses, :path => 'vestidos' do
    resources :dress_photos, :path => 'photos' do
      get 'bulk_edit', :on => :collection
      post 'bulk_update', :on => :collection
    end
    get 'update_share', :on => :member
    resources :appointments
    resources :bookmarks, :path => 'favoritos'
    resources :track_dresses
  end
  match 'vestidos/:dress_id/fornecedores/:vendor_id' => 'appointments#new', :as => :add_appointment
  
  resources :messages, path: 'contato' do
    get 'cadastro', :on => :collection
    get 'atualizacao', :on => :collection
    get 'termo', :on => :collection
    get 'pagamento', :on => :collection
  end

  match 'tracks/search_by_ip/:ip' => 'tracks#index', :as => :ip_search_tracks
  resources :tracks
  
  match 'statistics' => 'tracks#statistics', :as => :statistics_tracks
  match 'vestidos/:dress_id/statistics' => 'track_dresses#statistics', :as => :statistics_track_dresses
  match 'fornecedores/:vendor_id/tracks' => 'tracks#index', :as => :tracks_fornecedor
  match 'fornecedores/:vendor_id/tracks/statistics' => 'tracks#statistics', :as => :statistics_tracks_fornecedor
  match 'fornecedores/vestidos/:vid' => 'dresses#vendor', :as => :vestidos_fornecedor

  resources :quotations, :path => 'orcamentos' do
    get 'send_email', :on => :member
    get 'page/:page', :action => :index, :on => :collection
  end
  match 'fornecedores/:vendor_id/orcamentos' => 'quotations#index', :as => :orcamentos
  
  resources :feed_entries, :path => 'feeds' do
    get 'update_from_feed', :action => :update_from_feed, :on => :collection
    get 'update_categories', :action => :update_categories, :on => :collection
  end

  resources :reviews

  resources :authentications

  devise_for :users, :controllers => { :omniauth_callbacks => 'authentications',
                                       :registrations => 'registrations' },
                     :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'registro' },
                     :path_prefix => 'd'

  match 'u/:user_id/tracks/statistics' => 'tracks#statistics', :as => :statistics_tracks_user
  match 'u/:user_id/tracks/vestidos/statistics' => "track_dresses#statistics", :as => :user_statistics_track_dresses

  resources :users, :path => 'u', :controller => 'users' do
    get 'send_tester_email', :on => :member
    get 'create_invitation', :on => :collection
    get 'unsubscribe', :on => :member
    resources :tracks
    resources :appointments
    resources :track_dresses
  end
  match 'perfil' => "users#show"
  match 'convite/:token' => 'users#accepted_invitation'

  resources :searches, :path => 'busca' do
    get ':id/page/:page', :action => :show, :on => :collection
    post 'delete_old_searches', :action => :delete_old_searches, :on => :collection
  end
  
  resources :vendors, :path => 'fornecedores' do 
    post 'rate', :on => :member
    get 'mapa', :on => :member
    get 'telefone', :on => :member
    get 'site', :on => :member
    get 'ler_mais', :on => :member
    get 'desc', :on => :member
    get 'widget', :on => :collection
    get 'send_newsletter', :on => :collection
    get 'vendor_reviews', :on => :collection
    get 'user_request_proposal', :on => :member
    resources :photos do
      get 'bulk_edit', :on => :collection
      post 'bulk_update', :on => :collection
    end
    resources :bookmarks, :path => 'favoritos'
    resources :addresses, :path => 'enderecos'
    #resources :appointments
  end

  resources :bookmarks

  match 'quiz' => 'searches#new'
  match 'sobre-a-empresa' => 'site#about_us', :as => :about_us
  match 'reviewoftheday' => 'site#reviewoftheday', :as => :recomendacao_do_dia, :via => [:get,:post]
  match 'buscablog' => 'site#search', :as => :busca_blog
  
  match 'fornecedores/:service/:city/:id' => 'vendors#show', :as => :fornecedores
  match 'recomendacoes/:uid' => 'reviews#index', :as => :recomendacoes
  match ':id' => 'vendors#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'searches#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
