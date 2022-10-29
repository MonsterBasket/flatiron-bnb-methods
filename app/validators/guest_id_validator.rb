class GuestIdValidator < ActiveModel::Validator
  def validate(record)
    if record.guest_id == record.listing.host_id
      record.errors[:base] << 'Cannot make reservation on your own listing'
    end
  end
end