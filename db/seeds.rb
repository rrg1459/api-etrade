puts "============ Running seeds ============"

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

puts "============ Seeds completed ============"
