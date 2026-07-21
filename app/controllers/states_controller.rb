class StatesController < ApplicationController
  def show
    ticket = Ticket.find_by!(barcode: params[:ticket_barcode])

    render json: {
      barcode: ticket.barcode,
      state: ticket.state
    }, status: :ok
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ticket not found" }, status: :not_found
  end
end
