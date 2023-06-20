# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


#USERS SEEDS
puts "Destroying users..."
User.destroy_all
puts "Creating user..."
User.create!(
  email: "michel@hotmail.fr",
  encrypted_password: "123456"
  first_name: "Michel"
  last_name: "Aulas"
)
User.create!(
  email: "guillaume@hotmail.fr",
  encrypted_password: "123456"
  first_name: "Guillaume"
  last_name: "Roux"
)
puts "Finished create users!"

#HOBBIES SEEDS
puts "Destroying Hobbies..."
Hobby.destroy_all
puts "Creating Hobbies..."
Hobby.create!(
  name: "Football",
)
Hobby.create!(
  name: "Tennis",
)
puts "Finished create Hobbies!"


#REVIEWS SEEDS
puts "Destroying Reviews..."
Review.destroy_all
puts "Creating Reviews..."
Review.create!(
  comment: "Super tour !",
  rating: 5,
)
Review.create!(
  comment: "Nice tour !",
  rating: 3,
)
puts "Finished create Reviews!"
