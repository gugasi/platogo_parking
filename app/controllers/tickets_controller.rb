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
end
