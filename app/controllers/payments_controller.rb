class PaymentsController < ApplicationController
  def create
    ticket = Ticket.find_by!(barcode: params[:ticket_barcode])

    # Updated: Only block payment if they are currently within the 15-minute exit window[cite: 4]
    if ticket.within_exit_window?
      render json: { error: "Ticket is already paid and valid for exit" }, status: :unprocessable_entity
      return
    end

    if ticket.update(paid_at: Time.current, payment_method: params.require(:payment_method))
      render json: {
        barcode: ticket.barcode,
        paid_at: ticket.paid_at,
        payment_method: ticket.payment_method
      }, status: :ok
    else
      render json: { error: ticket.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ticket not found" }, status: :not_found
  rescue ActionController::ParameterMissing
    render json: { error: "payment_method is required" }, status: :bad_request
  end
end
