# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

puts "Création de 10 utilisateurs fictifs"
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
images = [
  "https://techcrunch.com/wp-content/uploads/2019/11/GettyImages-601763009.jpg?w=1390&crop=1",
  "https://static.wixstatic.com/media/82260f_72671b2e12c24236abe5d142339b3d35~mv2.jpg/v1/fill/w_520,h_420,al_c,lg_1,q_80,enc_auto/82260f_72671b2e12c24236abe5d142339b3d35~mv2.jpg",
  "https://misstourist.com/wp-content/uploads/2023/05/Vietnam-tour-companies-660x440@2x.jpg",
  "https://www.just-drinks.com/wp-content/uploads/sites/29/2023/01/shutterstock_1757555312-Cropped.jpg",
  "https://factsofindonesia.com/wp-content/uploads/2020/12/balis-most-popular-tourism-spot.jpg",
  "https://1.bp.blogspot.com/-KV7y1JEJZRE/YCoGmsfM-SI/AAAAAAAAD6Q/1m8TeTkDCD83Hk8AhexV_oIycqjav3RHQCLcBGAsYHQ/s1200/Kirkjufell%2BMountain.jpg",
  "https://www.travelandleisure.com/thmb/rbPz5_6COrWFh94qFRHYLJrRM-g=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/iguazu-falls-argentina-brazil-MOSTBEAUTIFUL0921-e967cc4764ca4eb2b9941bd1b48d64b5.jpg",
  "https://www.tourmyindia.com/blog//wp-content/uploads/2022/10/Best-Places-to-Visit-in-Bhutan-Tourism.jpg",
  "https://d2rdhxfof4qmbb.cloudfront.net/wp-content/uploads/20180221131008/iStock-627935066.jpg",
  "https://i.insider.com/55f892c2bd86ef1a008ba8c9?width=1136&format=jpeg"
]
li_hobbies = [
  Hobby.create!(name: "Football", icon: "link"),
  Hobby.create!(name: "Surf", icon: "link"),
  Hobby.create!(name: "Running", icon: "link"),
  Hobby.create!(name: "Art", icon: "link"),
  Hobby.create!(name: "Food", icon: "link"),
  Hobby.create!(name: "Cinema", icon: "link"),
  Hobby.create!(name: "Music", icon: "link"),
  Hobby.create!(name: "Martial arts", icon: "link")
]

puts 'Faux hobbies crée !'

i = 0
10.times do
  tour = Tour.new(
    name: Faker::Lorem.word,
    city: Faker::Address.city,
    description: Faker::Book.title,
    price: Faker::Number.between(from: 10, to: 100),
    number_of_travlers: Faker::Number.between(from: 1, to: 5),
    user_id: User.pluck(:id).sample
  )
  file = URI.open(images[i])
  tour.photos.attach(io: file, filename: 'photo.jpg')
  tour.save!
  num_rand = rand(1..5)
  selected_hobbies = li_hobbies.sample(num_rand)
  selected_hobbies.each do |hobby|
    tour.user.user_hobbies << UserHobby.create!(user_id: tour.user.id, tour_id: tour.id, hobby_id: hobby.id)
  end
  i += 1
  puts i
end

puts 'Faux tours créés !'


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
