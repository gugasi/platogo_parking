class TicketsController < ApplicationController
  def create
    ticket = Ticket.new

    if ticket.save
      render json: {
        barcode: ticket.barcode,
        issued_at: ticket.issued_at
      }, status: :created
    else
      render json: { error: ticket.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # --- NEW: Task 2 Endpoint ---
  def show
    # params[:barcode] comes from the route URL
    ticket = Ticket.find_by!(barcode: params[:barcode])

    render json: {
      barcode: ticket.barcode,
      price: ticket.calculate_price
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ticket not found" }, status: :not_found
  end
end
