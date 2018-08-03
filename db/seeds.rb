# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "Khanh Hung",
  email: "hungnk1995@gmail.com",
  phone_number: "0989115274",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true)

20.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  phone_number = Faker::PhoneNumber.phone_number
  User.create!(name: name,
    email: email,
    phone_number: phone_number,
    password: password,
    password_confirmation: password)
end

20.times do |n|
  Room.create! name: Faker::Job.title,
  home_type: ["Apartment", "House", "Bed & Breakfast"].sample,
  room_type: ["Entire", "Private", "Share"].sample,
  accommodate: rand(1..5),
  bed_room: rand(1..5),
  bath_room: rand(1..5),
  summary: Faker::Lorem.paragraphs,
  active: [true, false].sample,
  user_id: rand(2..21),
  is_tv: [true, false].sample,
  is_kitchen: [true, false].sample,
  is_air: [true, false].sample,
  is_heating: [true, false].sample,
  is_internet: [true, false].sample,
  price: rand(20..1000),
  address: ["Ha Noi", "Hai Phong"].sample
end

40.times do |n|
  price = rand(200..1000)
  Reservation.create! user_id: rand(2..21),
  room_id: rand(1..20),
  start_date: Time.now,
  end_date: 10.days.from_now,
  price: price,
  total: price * 10
end
