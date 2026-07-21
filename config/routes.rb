Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    resources :tickets, only: [:create, :show], param: :barcode do
      # This generates POST /api/tickets/{ticket_barcode}/payments
      resources :payments, only: [:create]
    end
  end
end
