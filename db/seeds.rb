
User.create(name: 'Beziq',
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: 'Śląskie',
  active: true,
  admin: true)
  
32.times do |n| 
  User.create(name: Faker::Name.name,
  password: 'asdfasdf',
  password_confirmation: 'asdfasdf',
  region: User::REGIONS[n % 16],
  active: true,
  admin: false)
end