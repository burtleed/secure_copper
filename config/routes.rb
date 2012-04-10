Securecopper::Application.routes.draw do

  #namespace :admin do resources :titles end

  namespace :admin do 
  	resources :roles
    resources :groups, :except=>[:show,:destroy] do
      collection do
        post :allinone
        match :add_users
      end
    end
    resources :hospitals, :except=>[:show,:destroy] do
      collection do
        post :allinone
      end
    end
    resources :titles, :except=>[:show,:destroy] do
      collection do
        post :allinone
      end
    end
  	resources :users, :except=>[:show,:destroy] do
      collection do
        post :allinone
        match :change_password
      end
    end
    
    resources :messages, :only=>[:index, :create,:new] do
      collection do
	      get :list
 			  post :search_contact
 			  match :set_recepients
 		  	post :delete_selected  
      end      
      member do 
      	delete :destroy
      end
    end
    
    resources :expire_settings_messages, :only => [:update,:new]
    
    match '/messages/:id/attachments' => "messages#show_attachments", :as => "show_attachments"    
    match '/messages/attachements/:id/download' => "messages#send_attachemnt_file", :as => "download_attachment"
    match '/users/get-user-list/:act' => "users#user_list", :as => "get_user_list"
  end

  devise_for :users, :controllers => {:sessions => "session", :passwords => "passwords"}, :path => "users", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }
  
  match '/messages/between_user/:user_id.(:format)' => 'messages#messages_between_user', :as => "messages_between_user" 
  
   resources :messages do
     collection do
       post :delete_selected       
     end
   end

  match '/temp_file_uploads/destroy/:id' =>'temp_file_uploads#destroy', :as => :temp_file_remote_delete
  match '/temp_file_uploads/delete/:id'=>'temp_file_uploads#destroy_file' , :as => :temp_file_delete
  match '/hospitalchange' => "admin/hospitals#change_hospital"
  resources :temp_file_uploads
  #resources :expire_settings_messages
  root :to => "home#index"

  get '/users/search(.:format)' => "users#search"   
  resources :users, :only => :index


  namespace :api do
   get '/users/messages/lifespan/get' => "expire_settings_messages#show"
   post '/users/messages/lifespan/set' => "expire_settings_messages#update"
   match '/messages/between_user/:user_id' => "messages#messages_between_user"
  	resources :users, :only => [:index] do
  	  collection do 
  		  get 'search'
  		  post 'update_data'
  	  end
  	end
   resources :messages, :only => [:index,:show,:create,:destroy] 
   resources :groups, :only => [:index] do 
   	member do 
   		get 'group_users'
   		get 'hospital_groups_users'
   	end
   	collection do 
   		get 'hospital_groups'
   	end
   end
  end
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
