Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    # Added :show for Task 2
    resources :tickets, only: [:create, :show], param: :barcode
  end
end
