class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  before_save :make_host
  before_destroy :remove_host

  def average_review_rating
    if self.reviews.count > 0
      self.reviews.reduce(0) { |total, review| review.rating.to_f + total} / self.reviews.count
    else
      0
    end
    # reviews.average(:rating)
  end

  def is_available?(start_date, end_date)
    self.reservations.none? do |reservation|
      (reservation.checkin >= start_date.to_date && reservation.checkin < end_date.to_date) ||
      (reservation.checkout > start_date.to_date && reservation.checkout <= end_date.to_date) ||
      (reservation.checkin <= start_date.to_date && reservation.checkout >= end_date.to_date)
    end
  end

  private
  def make_host
    self.host.update(host: true)
  end

  def remove_host
    self.host.update(host: false) if self.host.listings.count <= 1
  end
end
