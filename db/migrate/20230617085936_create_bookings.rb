class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.date :date
      t.boolean :confirmation
      t.references :user, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true

      t.timestamps
    end
  end
end
