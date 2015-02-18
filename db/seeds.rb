
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

inactive_users = User.where(active: false)
inactive_users.each { |user| user.deactivate_offers }

# categories creation
Category::NAME_CODES.each do |name_c|
  Category.create(name_code: name_c )
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