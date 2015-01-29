
# users creation
User.create(name: 'Beziq',
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: 'Śląskie',
  active: true,
  admin: true)
  
50.times do |n| 
  User.create(name: Faker::Name.name,
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: User::REGIONS[n % 16],
  active: true,
  admin: false)
end

# categories creation
Category::NAMES.each_index do |i|
  Category.create(name_id: i )
end

# offers creation
User.all.each do |user|
  50.times do |n|
    user.offers.create(
      title: "#{Faker::Commerce.product_name} #{Faker::Lorem.word}",
      content: Faker::Lorem.sentence(rand(3..9)),
      valid_until: (Time.zone.today + rand(1..90).days),
      status_id: ( n % 3 ),
      category_id: rand(1..12)
      )
  end
end