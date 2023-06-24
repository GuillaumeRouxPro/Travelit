class Hobby < ApplicationRecord
  has_many :user_hobbies, dependent: :destroy
  has_many :tours, through: :user_hobbies
end
