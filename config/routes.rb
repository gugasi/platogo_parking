Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    resources :tickets, only: [:create, :show], param: :barcode do
      resources :payments, only: [:create]
      
      # --- NEW: Task 4 State Route ---
      resource :state, only: [:show]
    end
  end
end
