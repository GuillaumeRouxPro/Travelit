class UserHobby < ApplicationRecord
  belongs_to :user
  belongs_to :hobby
  belongs_to :tour
end
