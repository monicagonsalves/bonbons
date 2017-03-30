Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
 root to: 'home#index'
 
 get '/flashcards', to: "master_stack#show_stack", as: :flashcards
 get 'stacks/master', to: 'master_stack#show_stack'

 resources :flashcards, only: [:edit, :show, :update, :destroy] do 
    collection do 
       get  'new_batch'
       post 'create_batch'
    end 
 end 
 
 get    '/stacks',                   to: 'stacks#index', as: :stacks_index
 post   '/stacks',                   to: 'stacks#find' 

 get    'stacks/by_tag/:id' ,        to: 'user_defined_tags#show_stack', as: :stacks_by_user_defined_tag
 get    'stacks/by_batch/:id',       to: 'batches#show_stack',                     constraints: {id: /[0-9]+/}, as: :stacks_by_batch
 get    'stacks/by_langs/:id',       to: 'language_pairs#show_stack',              constraints: {id: /[a-z]{2,3}_[a-z]{2,3}/ }, as: :stacks_by_langs

 get    'stacks/by_tag/:id/study',   to: 'user_defined_tags#study_stack', as: :study_stack_by_user_defined_tag
 get    'stacks/by_batch/:id/study', to: 'batches#study_stack',                    constraints: {id: /[0-9]+/}, as: :study_stack_by_batch
 get    'stacks/by_langs/:id/study', to: "language_pairs#study_stack",             constraints: {id: /[a-z]{2,3}_[a-z]{2,3}/ }, as: :study_stack_by_langs 
 get    'stacks/master/study',       to: "master_stack#study_stack",  as: :study_master_stack

 delete 'stacks/master',       to: 'master_stack#destroy_stack'
 delete 'stacks/by_batch/:id', to: 'batches#destroy_stack',                  constraints: {id: /[0-9]+/}
 delete 'stacks/by_langs/:id', to: 'language_pairs#destroy_stack',           constraints: {id: /[a-z]{2,3}_[a-z]{2,3}/ }
 delete 'stacks/by_tag/:id',   to: 'user_defined_tags#destroy_stack',        constraints: {id: /[0-9]+/}


 resources :user_defined_tags, only:[:edit, :update, :destroy, :new, :create] do
    collection do 
      get '/:id/flashcards', to: 'user_defined_tags#show_stack', as: :user_defined_tag_stack
    end
 end

 resources :tags, only: [:index]

 post '/tags', to: 'tags#find'
 post '/tags/delete_all', to: 'tags#delete_all'

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
