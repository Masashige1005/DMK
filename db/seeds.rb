# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: 'aaa',
             email: 'aa@aa',
             password: 'aaaaaa',
             introduction: 'aaaaaa',
             profile_image_id: 'bbbbb')

20.times do |_n|
  Song.create!(name: Faker::Music::GratefulDead.song,
               artist: Faker::Artist.name,
               description: Faker::Quotes::Shakespeare.as_you_like_it_quote,
               vid: 'btrzs54s1Rc',
               user_id: 1,
               lylics_url: 'https://genius.com/Jonas-blue-rise-lyrics')
end
