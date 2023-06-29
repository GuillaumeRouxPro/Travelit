# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

# Création de 10 utilisateurs fictifs
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123456' # Vous pouvez définir un mot de passe par défaut pour les utilisateurs fictifs
  )
end

puts 'Faux utilisateurs créés !'

# Crée 10 faux tours
10.times do
  tour = Tour.new(
    name: Faker::Lorem.word,
    city: Faker::Address.city,
    description: Faker::Lorem.paragraph,
    price: Faker::Number.between(from: 10, to: 100),
    number_of_travlers: Faker::Number.between(from: 1, to: 5),
    user_id: User.pluck(:id).sample
  )

  # Ajoute une photo au tour
  file = URI.open('https://www.autour-dumonde.fr/sx-content/uploads/cms/img-presentation-1.jpg') # Remplacez l'URL par l'URL de votre photo
  tour.photos.attach(io: file, filename: 'photo.jpg')

  tour.save!
end
