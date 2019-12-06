# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


20.times do |n|
 Song.create!(name: Faker::Music::GratefulDead.song,
 			  artist: Faker::Artist.name,
 			  description: Faker::Quotes::Shakespeare.as_you_like_it_quote,
 			  video_id: 'btrzs54s1Rc'
 			  )
end

	User.create!(name: 'aaa',
				 email: 'aa@aa',
				 password: 'aaaaaa',
				 introduction: 'aaaaaa')