class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.text :name
      t.string :city
      t.text :description
      t.integer :price
      t.integer :number_of_travlers
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
