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

  def new
    @tour = Tour.new
    authorize @tour
  end

  def self.search(hobbies, city, date, num_travelers)
    tours = self.all

    tours = tours.where(hobby_id: hobbies) if hobbies.present?
    tours = tours.where(city: city) if city.present?
    tours = tours.where(date: date) if date.present?
    tours = tours.where("max_travelers >= ?", num_travelers.to_i) if num_travelers.present?

    tours
  end
end
