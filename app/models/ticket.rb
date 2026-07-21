class Ticket < ApplicationRecord
  MAX_SPACES = 54
  HOURLY_RATE = 2.0 # €2 per hour

  scope :active_in_lot, -> { where(exited_at: nil) }

  validates :barcode, presence: true, uniqueness: true, format: { with: /\A[a-f0-9]{16}\z/i }
  validates :issued_at, presence: true
  validate :parking_lot_must_have_capacity, on: :create

  before_validation :generate_barcode_and_issued_at, on: :create

  # --- NEW: Task 2 Pricing Logic ---
  def calculate_price
    duration_in_seconds = Time.current - issued_at
    started_hours = (duration_in_seconds / 1.hour.to_f).ceil
    
    # If less than a minute has passed, it still counts as 1 started hour
    started_hours = 1 if started_hours.zero? 
    
    started_hours * HOURLY_RATE
  end

  private

  def generate_barcode_and_issued_at
    self.barcode ||= SecureRandom.hex(8) 
    self.issued_at ||= Time.current
  end

  def parking_lot_must_have_capacity
    if Ticket.active_in_lot.count >= MAX_SPACES
      errors.add(:base, "Parking lot is full. Maximum capacity of #{MAX_SPACES} reached.")
    end
  end
end
