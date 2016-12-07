# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', confirmed_at: Time.now, admin: true)
food = Food.create(name: "라면", weight: 120, calorie: 510)
FoodUnit.create(name: "그릇", weight_per_unit: 120, food: food)
