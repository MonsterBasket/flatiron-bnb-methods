class CheckinValidator < ActiveModel::Validator
  def validate(record)
    if (record.checkin && record.checkout) && !record.listing.is_available?(record.checkin, record.checkout)
      record.errors[:base] << 'Listing not available on these dates'
    end
    if (record.checkin && record.checkout) && (record.checkin >= record.checkout)
      record.errors[:base] << 'Check-in must be before check-out'
    end
  end
end