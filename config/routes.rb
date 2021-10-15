Bonnie::Application.routes.draw do
  use_doorkeeper do
    skip_controllers :token_info
    controllers authorizations: 'doorkeeper_override/authorizations'
  end
  # override doorkeeper token info endpoint
  get '/oauth/token/info' => 'doorkeeper_override/token_info#show'
  # add OAuth change user endpoint
  post '/oauth/authorize/change_user' => 'doorkeeper_override/authorizations#change_user'

  apipie
  devise_for :users, :controllers => { :registrations => "registrations" }

  devise_scope :user do
    get "/needs_approval" => "registrations#needs_approval"
  end

  authenticated do
    root to: 'home#index', as: 'authenticated_root'
  end

  unauthenticated do
    root to: 'home#show', as: 'unauthenticated_root'
  end

  get '404', :to => 'application#page_not_found'
  get '500', :to => 'application#server_error'

  # switch user group route
  get '/user/switch_group/:group_id', to: 'home#switch_group'

  # The following route is for the reporting of front end (javascript) errors
  # to the backend.
  post '/application/client_error' => 'application#client_error'

  get 'user/registered_not_active', to: 'home#registered_not_active'

  root to: 'home#index'

  resources :measures, defaults: { format: :json } do
    collection do
      post 'finalize'
      post 'cql_to_elm'
    end
    member do
      get 'debug', defaults: { format: :html }
      post 'clear_cached_javascript'
      post 'measurement_period'
    end
    resources :populations do
      member do
        get 'calculate_code'
      end
    end
    resources :populations
  end

  namespace :vsac_util do
    get 'profile_names'
    get 'program_names'
    get 'program_release_names/:program', to: '/vsac_util#program_release_names'
    get 'auth_valid'
    post 'auth_expire'
  end

  resources :patients do
    collection do
      post 'materialize'
      post 'qrda_export'
      post 'excel_export'
      post 'share_patients'
      post 'convert_patients'
      post 'json_export'
      post 'json_import'
      post 'delete_all_patients'
    end
  end

  namespace :admin do
    resources :users do
      collection do
        post 'email_active'
        post 'email_all'
        post 'email_single'
        get 'user_by_email'
        get 'users_by_group'
        post 'update_group_and_users'
        post 'update_groups_to_a_user'
      end
      member do
        post 'approve'
        post 'disable'
        get 'patients'
        get 'measures'
        post 'log_in_as'
      end
    end
    resources :groups do
      collection do
        post 'create_group'
        post 'get_groups_by_group_ids'
        get 'find_group_by_name'
      end
    end
  end

  namespace :api_v1 do
    resources :measures, :defaults => { :format => 'json' }, :only => [:index, :show, :create, :update] do
      member do
        # get 'patients' # disabled until QDM models are better integrated
        get 'calculated_results'
      end
    end
  end

  namespace :complexity_dashboard do
    resources :measure_sets
  end

  resources :valuesets

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
