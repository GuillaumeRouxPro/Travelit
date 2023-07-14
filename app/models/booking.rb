class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :tour

  has_many :reviews, dependent: :destroy

  attribute :start_date, :date
  attribute :end_date, :date

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "Vérifiez la date") if start_date >= end_date
  end

  def start_date_must_be_after_today
    errors.add(:end_date, "Les dates sont passées !") if Date.today > start_date
  end

end
