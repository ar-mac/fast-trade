
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
  active: n % 2 == 0 ? true : false,
  admin: false)
end

# categories creation
Category::NAME_CODES.each do |name_c|
  Category.create(name_code: name_c )
end

# offers creation
User.all.each do |user|
  50.times do |n|
    user.offers.create(
      title: "#{Faker::Commerce.product_name} #{Faker::Lorem.word}",
      content: Faker::Lorem.sentence(6),
      valid_until: ( Time.zone.today + rand(1..90).days ),
      status_id: ( user.active? ? (n % 3) : (2) ),
      category_id: ( n % 12 + 1 ),
      price: ( n % 4 == 0 ? 0 : ((n + 2) * 4) )
      )
  end
end