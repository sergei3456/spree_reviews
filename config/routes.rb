# frozen_string_literal: true

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :reviews, only: %i[index destroy edit update] do
      member do
        get :approve
      end
      resources :feedback_reviews, only: %i[index destroy]
    end
    resource :review_settings, only: %i[edit update]
  end

  resources :products, only: [] do
    resources :reviews, only: %i[index new create] do
    end
  end
  post '/reviews/:review_id/feedback(.:format)' => 'feedback_reviews#create', as: :feedback_reviews

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do

      namespace :storefront do
        resources :reviews, only: %i[show index create] do
          get '/settings', action: :setting, controller: 'reviews', as: :review_settings, on: :collection
        end
        resources :feedback_reviews, only: [:create]
      end
    end
  end
end
