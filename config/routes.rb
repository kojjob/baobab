Rails.application.routes.draw do
  # Health check and root route
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"

  # Authentication
  devise_for :users

  # User profiles
  resources :profiles do
    member do
      patch :restore
      patch :deactivate
      patch :activate
      patch :block
      patch :unblock
      patch :follow
      patch :unfollow
      post :increment_views
    end

    collection do
      get :my_profile
    end
  end

  # Shop/Marketplace Routes
  resources :merchants
  resources :products do
    resources :reviews, only: [ :create, :index ]
  end

  # Use singular resource for cart (users only have one cart)
  resource :cart, only: [ :show, :update ] do
    resources :cart_items, only: [ :create, :update, :destroy ]
  end

  resources :orders do
    resources :order_items, only: [ :index ]
  end
  resources :order_items, only: [ :show, :update, :destroy ]

  # Categories
  resources :categories, only: [ :index, :show ]
  resources :tags, only: [ :show ]

  # Blog system routes
  scope :blog do
    get "/", to: "posts#index", as: :blog

    # Subscriptions
    resources :subscriptions, only: [ :new, :create ]
    get "subscriptions/confirm/:token", to: "subscriptions#confirm", as: :confirm_subscription
    get "subscriptions/unsubscribe/:token", to: "subscriptions#unsubscribe", as: :unsubscribe_subscription

    # RSS feed
    get "feed", to: "posts#index", format: "rss", as: :blog_feed
  end

  # Posts resources (not namespaced)
  resources :posts do
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  # User dashboard
  namespace :dashboard do
    get "/", to: "home#index"
    resources :posts
    resources :comments, only: [ :index, :destroy ]
  end

  # Admin dashboard and blog management
  namespace :admin do
    root "dashboard#index"

    resources :posts do
      member do
        patch :publish
        patch :unpublish
      end
    end

    resources :categories
    resources :tags

    resources :comments, only: [ :index, :show, :destroy ] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :subscriptions, only: [ :index, :show, :destroy ]
  end

  # Static pages
  get "about" => "home#about", as: :about
  get "user_guides" => "home#user_guides", as: :user_guides
  get "contact" => "home#contact", as: :contact
  get "terms" => "home#terms", as: :terms
  get "privacy" => "home#privacy", as: :privacy
  get "cookies" => "home#cookies", as: :cookies
  get "explore" => "home#explore", as: :explore
  get "help_center" => "home#help_center", as: :help_center
  get "notifications" => "home#notifications", as: :notifications
  get "settings" => "home#settings", as: :settings
  get "news_press" => "home#news_press", as: :news_press
  get "careers" => "home#careers", as: :careers
  get "community" => "home#community", as: :community
  get "search" => "home#search", as: :search
  get "promotions" => "home#promotions", as: :promotions
  get "events" => "home#events", as: :events

  # Error pages
  get "404" => "home#not_found", as: :not_found
  get "500" => "home#internal_server_error", as: :internal_server_error
  get "503" => "home#service_unavailable", as: :service_unavailable
  get "504" => "home#gateway_timeout", as: :gateway_timeout
end
