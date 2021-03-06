require 'faker'

rand(10..30).times do
  password = Faker::Lorem.characters(10)
  u = User.new(
    first_name: Faker::Name.first_name, 
    last_name: Faker::Name.last_name, 
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password, 
    phone_number: Faker::PhoneNumber.cell_phone, 
    active: true)
  u.save
end

rand(10..30).times do
  b = Building.new(
    street: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip)
  b.save
  rand(10..30).times do
    a = b.apartments.create(
      unit: Faker::Lorem.characters(3),
      bedrooms: Faker::Number.digit,
      bathrooms: Faker::Number.digit,
      floorplan: Faker::Lorem.characters(10),
      image: Faker::Lorem.characters(10))
    a.save
  end
end

User.all.each do | x |
  offset = rand(Apartment.count)
  rand_record = Apartment.first(:offset => offset)
  start_date = DateTime.now - rand(600..31536000)
  end_date = start_date + 1.year
  au = ApartmentUser.create(
    apartment_id: rand_record.id,
    user_id: x.id,
    lease_start: start_date,
    lease_end: end_date,
    active: true)
  2.times do
    mr = x.maintenance_requests.create(
      status: "Open",
      priority: "High",
      description: Faker::Lorem.paragraph,
      email_updates: true)
    rand(2..5).times do
      offset2 = rand(User.count)
      rand_record2 = User.first(:offset => offset2)
      mr.maintenance_comments.create(
        user_id: rand_record2.id,
        comment: Faker::Lorem.paragraph)
    end
  end
end


u = User.new(
  email: 'admin@probono.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld', 
  first_name: "Admin", 
  last_name: "Example", 
  apartment_validation: "1234",
  approved: true,
  active: true)
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  email: 'tenant@probono.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld', 
  first_name: "Tenant", 
  last_name: "Example", 
  apartment_validation: "1234",
  approved: true,
  active: true)
u.save
u.update_attribute(:role, 'tenant')

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Building.count} buildings created."
puts "#{Apartment.count} apartments created."
puts "#{MaintenanceRequest.count} maintenance requests created."
puts "#{MaintenanceComment.count} comments created."