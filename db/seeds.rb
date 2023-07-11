# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

# Création de 10 utilisateurs fictifs


UserHobby.destroy_all
Tour.destroy_all
User.destroy_all
Hobby.destroy_all

10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123456'
  )
end

puts 'Faux utilisateurs créés !'

10.times do
  tour = Tour.new(
    name: Faker::Lorem.word,
    city: Faker::Address.city,
    description: Faker::Book.title,
    price: Faker::Number.between(from: 10, to: 100),
    number_of_travlers: Faker::Number.between(from: 1, to: 5),
    user_id: User.pluck(:id).sample
  )
  file = URI.open(Faker::LoremFlickr.image(size: "320x240", search_terms: ['travel'], match_all: true))
  tour.photos.attach(io: file, filename: 'photo.jpg')

  tour.save!
end

puts 'Faux tours créés !'

li_hobbies = [
  Hobby.create!(name: "Football", icon: "link"), Hobby.create!(name: "Tennis", icon: "link"),
  Hobby.create!(name: "Swimming", icon: "link"),
  Hobby.create!(name: "Running", icon: "link"),
  Hobby.create!(name: "Golf", icon: "link"),
  Hobby.create!(name: "Martial arts", icon: "link")
]

puts 'Faux hobbies crée !'
# 6.times do
#   User_Hobby.create!(
#     name: Faker::Lorem.word,
#     icon: Faker::Lorem.word
#   )
# end

# puts 'Faux hobbies créés !'

# 10.times do
#   tour = Tour.all.sample
#   hobby = Hobby.create!(
#     name: Faker::Lorem.word,
#     icon: Faker::Lorem.word
#   )
#   tour.user.hobbies << hobby
# end

# puts 'Faux hobbies de tour créés !'
