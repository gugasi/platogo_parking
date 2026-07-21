class Ticket < ApplicationRecord
  MAX_SPACES = 54
  HOURLY_RATE = 2.0 # €2 per hour
  
  # --- NEW: Task 4 Constant ---
  EXIT_WINDOW = 15.minutes

  scope :active_in_lot, -> { where(exited_at: nil) }

  validates :barcode, presence: true, uniqueness: true, format: { with: /\A[a-f0-9]{16}\z/i }
  validates :issued_at, presence: true
  validate :parking_lot_must_have_capacity, on: :create
  validates :payment_method, inclusion: { in: %w[credit_card debit_card cash] }, allow_nil: true

  before_validation :generate_barcode_and_issued_at, on: :create

  # --- NEW: Task 4 Exit Logic ---
  def within_exit_window?
    paid_at.present? && (Time.current - paid_at <= EXIT_WINDOW)
  end

  def state
    within_exit_window? ? "paid" : "unpaid"
  end

  def calculate_price
    # Updated: Price is only 0.0 if paid AND within the 15-minute window
    return 0.0 if within_exit_window?

    duration_in_seconds = Time.current - issued_at
    started_hours = (duration_in_seconds / 1.hour.to_f).ceil
    
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
