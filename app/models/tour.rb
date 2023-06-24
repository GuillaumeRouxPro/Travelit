class Tour < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 40, too_long: 'Le nom doit faire moins de %{count} caractères' }
  validates :city, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :number_of_travlers, numericality: { greater_than: 0 }
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_many_attached :photos
  validates :photos, presence: { message: "Merci d'ajouter au moins une photo" }
  has_many :user_hobbies, dependent: :destroy
  has_many :hobbies, through: :user_hobbies
end
