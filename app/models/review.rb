class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :booking_complete

  private

  def booking_complete
    return if !reservation
    if !reservation.checkout || reservation.checkout > Date.today
      errors.add(:reservation, 'You cannot leave a review until after you have checked out')
    end
    if reservation.status != 'accepted'
      errors.add(:reservation, 'Your booking was not confirmed')
    end
  end
end
