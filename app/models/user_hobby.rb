class UserHobby < ApplicationRecord
  belongs_to :user_id
  belongs_to :hobbies
end
