Rails.application.routes.draw do

  root "products#index"

   get "/admin/portal" => "admins#portal"


  namespace :admin do
    get "/dashboard" => "analytics#dashboard"
    resources :categories
    resources :products
    resources :users
    resources :addresses
    resources :order_contents
    resources :orders
    patch "/orders/:id/update_quantity" => "orders#update_quantity",                                  as: "update_quantity"
    post "/orders/:id/add_products" => "orders#add_products",
                                        as: "add_products"
  end

  resources :products, :only => [:index, :show]
  resource :session, :only => [:new, :create, :destroy]
  resources :orders, :only => [:update, :checkout]
  resource :user, :only => [:new, :edit, :update, :destroy]
  get "/checkout" => "orders#checkout", as: 'checkout'
  get "/shopping_cart" => "carts#shopping_cart", as: "cart"

  # get '/orders/:id', to: 'orders#order_list'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
