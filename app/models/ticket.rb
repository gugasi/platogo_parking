class Ticket < ApplicationRecord
  MAX_SPACES = 54

  # Scope to easily find cars currently in the lot
  scope :active_in_lot, -> { where(exited_at: nil) }

  # Validations
  validates :barcode, presence: true, uniqueness: true, format: { with: /\A[a-f0-9]{16}\z/i }
  validates :issued_at, presence: true
  validate :parking_lot_must_have_capacity, on: :create

  # Callbacks
  before_validation :generate_barcode_and_issued_at, on: :create

  private

  def generate_barcode_and_issued_at
    # SecureRandom.hex(8) generates exactly 16 hex characters
    self.barcode ||= SecureRandom.hex(8) 
    self.issued_at ||= Time.current
  end

  def parking_lot_must_have_capacity
    if Ticket.active_in_lot.count >= MAX_SPACES
      errors.add(:base, "Parking lot is full. Maximum capacity of #{MAX_SPACES} reached.")
    end
  end
end
