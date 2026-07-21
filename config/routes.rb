Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    # im gonna use param: :barcode so future routes look like /api/tickets/{barcode}
    resources :tickets, only: [:create], param: :barcode
  end
end
