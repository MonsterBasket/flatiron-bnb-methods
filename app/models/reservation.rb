class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout, :listing_id
  validate :checkin_checkout_checker
  validate { errors.add(:guest_id, "Can't make a reservation on your own listing") if guest_id == listing.host_id }
  # validates_with GuestIdValidator, CheckinValidator

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def checkin_checkout_checker
    return if !checkin || !checkout
    if !listing.is_available?(checkin, checkout)
      errors.add(:checkin, 'Listing not available on these dates')
    end
    if checkin >= checkout
      errors.add(:checkin, 'Check-in must be before check-out')
    end
  end

end
