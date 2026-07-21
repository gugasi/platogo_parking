class FreeSpacesController < ApplicationController
  def index
    total_spaces = Ticket::MAX_SPACES
    # active_in_lot is the scope I had created earlier (where exited_at: nil)
    taken_spaces = Ticket.active_in_lot.count
    free_spaces = total_spaces - taken_spaces

    render json: {
      total_spaces: total_spaces,
      free_spaces: free_spaces,
      taken_spaces: taken_spaces
    }, status: :ok
  end
end