class Booking < ApplicationRecord
  belongs_to :user_id
  belongs_to :tour_id
end
