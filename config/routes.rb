Rails.application.routes.draw do
  # Health check and root route
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"

  # Authentication
  devise_for :users

  # User Management
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

  # Marketplace/Shop
  concern :addressable do
    resources :addresses, only: [ :new, :create, :edit, :update, :destroy ]
  end

  resources :merchants do
    member do
      post :toggle_feature
      delete :remove_document
    end

    resources :products
    resources :orders, only: [ :index, :show, :update ]
    resources :announcements, except: [ :show ]
    resources :reviews, only: [ :index ]

    concerns :addressable
  end

  resources :products do
    resources :reviews, only: [ :create, :index ]
  end

  # Cart & Orders
  resource :cart, only: [ :show, :update ] do
    resources :cart_items, only: [ :create, :update, :destroy ]
  end

  resources :orders do
    resources :order_items, only: [ :index ]
  end
  resources :order_items, only: [ :show, :update, :destroy ]

  # Categories & Tags
  resources :categories, only: [ :index, :show ]
  resources :tags, only: [ :show ]

  # Address resource (global)
  resources :addresses
  resources :announcements

  # Blog System
  scope :blog do
    get "/", to: "posts#index", as: :blog

    # Subscriptions
    resources :subscriptions, only: [ :new, :create ]
    get "subscriptions/confirm/:token", to: "subscriptions#confirm", as: :confirm_subscription
    get "subscriptions/unsubscribe/:token", to: "subscriptions#unsubscribe", as: :unsubscribe_subscription

    # RSS feed
    get "feed", to: "posts#index", format: "rss", as: :blog_feed
  end

  # Posts and Comments
  resources :posts do
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  # User Dashboard
  namespace :dashboard do
    get "/", to: "home#index"
    resources :posts
    resources :comments, only: [ :index, :destroy ]
  end

  # Admin Dashboard
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

  # Static Pages
  %w[
    about user_guides contact terms privacy cookies explore
    help_center notifications settings news_press careers
    community search promotions events
  ].each do |page|
    get page, to: "home##{page}", as: page.to_sym
  end

  # Error Pages
  %w[not_found internal_server_error service_unavailable gateway_timeout].each do |error|
    get error.gsub("_", "-"), to: "home##{error}", as: error.to_sym
  end
end
