Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
 root to: 'home#index'
 
 get '/flashcards', to: "stacks#master", as: :flashcards
 get 'stacks/master', to: 'stacks#master'

 resources :flashcards, only: [:edit, :show, :update, :destroy] do 
    collection do 
       get  'new_batch'
       post 'create_batch'
       get  'search' 
    end 
 end 
 
 # Following two routes both generate stacks by based on tags
 get    '/user_defined_tags/:id/flashcards',to: 'stacks#by_user_defined_tag', as: :user_defined_tag_stack 
 get    '/stacks/by_tag/:id' ,to: 'stacks#by_user_defined_tag', as: :stacks_by_user_defined_tag

 get    '/stacks',             to: 'stacks#index', as: :stacks_index
 get    'stacks/by_batch/:id', to: 'stacks#by_batch', constraints: {id: /[0-9]+/}, as: :stacks_by_batch
 get    'stacks/by_langs/:id', to: 'stacks#by_langs', constraints: {id: /[a-z]{2,3}_[a-z]{2,3}/ }, as: :stacks_by_langs
 
 delete 'stacks/master',       to: 'stacks#destroy_master'
 delete 'stacks/by_batch/:id', to: 'stacks#destroy_by_batch',                constraints: {id: /[0-9]+/}
 delete 'stacks/by_langs/:id', to: 'stacks#destroy_by_langs',                constraints: {id: /[a-z]{2,3}_[a-z]{2,3}/ }
 delete 'stacks/by_tag/:id',   to: 'stacks#destroy_by_user_defined_tag_tag', constraints: {id: /[0-9]+/}

 resources :user_defined_tags, only:[:edit, :update, :destroy, :new, :create, :index]
 resources :tags, only: [:index]

 get '/credits', to: 'credits#index', as: :credits

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
