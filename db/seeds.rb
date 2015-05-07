def msg(desciption, time)
  puts "-- #{desciption}\n   -> #{(Time.now - time).seconds.round(4)}s"
end
puts "\n---- SEEDS ----\n"
total_start = Time.now
User.delete_all
Category.delete_all
Offer.delete_all
msg('Database cleared', total_start)

#project creation
operation_start = Time.now
Project.create
msg('Project created', operation_start)

# admin creation
operation_start = Time.now
User.create(
  name: 'Beziq',
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: 'Śląskie',
  active: true,
  admin: true
)
msg('Admin user created', operation_start)

# users creation
operation_start = Time.now
32.times do |n| 
  User.create(
    name: Faker::Name.name,
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: User::REGIONS[n % 16],
  active: n % 2 == 0 ? true : false,
  admin: false
)
end
msg('Users created', operation_start)

# categories creation
operation_start = Time.now
Category::NAME_CODES.each do |name_c|
  Category.find_or_create_by(name_code: name_c)
end
msg('Categories created', operation_start)

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
msg('Offers created', operation_start)

puts "-" * 25
msg('Total time', total_start)