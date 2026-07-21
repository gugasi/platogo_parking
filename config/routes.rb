Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    # --- NEW: Task 5 Free Spaces Route ---
    get 'free-spaces', to: 'free_spaces#index'

    resources :tickets, only: [:create, :show], param: :barcode do
      resources :payments, only: [:create]
      resource :state, only: [:show]
    end
  end
end
