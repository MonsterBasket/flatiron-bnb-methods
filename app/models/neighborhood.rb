class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  # def neighborhood_openings(start_date, end_date)
  #   listings.all.map do |listing|
  #     listing unless listing.reservations.any? do |reservation|
  #       (reservation.checkin > start_date.to_date && reservation.checkin < end_date.to_date) ||
  #       (reservation.checkout > start_date.to_date && reservation.checkout < end_date.to_date)
  #     end
  #   end
  # end

  def neighborhood_openings(start_date, end_date)
    listings.all.filter { |listing| listing.is_available?(start_date, end_date) }
  end

  def self.highest_ratio_res_to_listings
    highest = [{}, 0]
    all.each{|nhood| 
      ratio = nhood.listings.count > 0 ? nhood.reservations.count / nhood.listings.count : 0
      highest = [nhood, ratio] if ratio > highest[1] 
    }
    highest[0]
  end

  def self.most_res
    most = [{}, 0]
    all.each{ |nhood|
      most = [nhood, nhood.reservations.count] if nhood.reservations.count > most[1]
    }
    most[0]
  end
end
