total_start = Time.now
User.delete_all
Category.delete_all
Offer.delete_all
puts "Database cleared (in #{(Time.now - total_start).seconds.round(2)}s)"

# admin creation
operation_start = Time.now
User.create(name: 'Beziq',
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: 'Śląskie',
  active: true,
  admin: true)
puts "Admin user created - Beziq (in #{(Time.now - operation_start).seconds.round(2)}s)"

# users creation
operation_start = Time.now
32.times do |n| 
  User.create(name: Faker::Name.name,
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: User::REGIONS[n % 16],
  active: n % 2 == 0 ? true : false,
  admin: false)
end
puts "Users created (in #{(Time.now - operation_start).seconds.round(2)}s)"

# categories creation
operation_start = Time.now
Category::NAME_CODES.each do |name_c|
  Category.find_or_create_by(name_code: name_c )
end
puts "Categories created (in #{(Time.now - operation_start).seconds.round(2)}s)"

# offers creation
operation_start = Time.now
User.all.each do |user|
  20.times do |n|
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
puts "Offers created (in #{(Time.now - operation_start).seconds.round(2)}s)"
puts "-" * 25
puts "Total time (#{(Time.now - total_start).seconds.round(2)}s)"