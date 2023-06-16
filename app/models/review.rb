class Review < ApplicationRecord
  belongs_to :user_id
  belongs_to :booking_id
end
