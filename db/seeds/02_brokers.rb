puts "02 Creating brokers..."

BROKERS = [
  { name: 'eTrade', api_base_url: 'https://apisb.etrade.com' },
  { name: 'schwab', api_base_url: 'https://api.schwabapi.com' },
].freeze

puts
puts '*'*40
puts '*'*40
puts "--> #{__method__} <--"
puts
puts "BROKERS: #{BROKERS}"
puts
puts '*'*40
puts '*'*40
puts

BROKERS.each { |broker| Broker.find_or_create_by! broker }

puts "02 Brokers successfully created"
