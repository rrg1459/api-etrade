puts "01 Creating users..."

USERS = [
  { name: 'superadmin', email: 'superadmin@mail.com' },
  { name: 'admin', email: 'admin@mail.com' },
  { name: 'operator', email: 'operator@mail.com' },
].freeze

USERS.each { |user| User.find_or_create_by! user }

puts "01 Users successfully created"
