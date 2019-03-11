# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# UK Regions + NUTS codes
regions = [
  {nuts_code: 'UKC', name: 'North East'},
  {nuts_code: 'UKD', name: 'North West'},
  {nuts_code: 'UKE', name: 'Yorkshire and the Humber'},
  {nuts_code: 'UKF', name: 'East Midlands'},
  {nuts_code: 'UKG', name: 'West Midlands'},
  {nuts_code: 'UKH', name: 'East of England'},
  {nuts_code: 'UKI', name: 'Greater London'},
  {nuts_code: 'UKJ', name: 'South East'},
  {nuts_code: 'UKK', name: 'South West'},
  {nuts_code: 'UKL', name: 'Wales'},
  {nuts_code: 'UKM', name: 'Scotland'},
  {nuts_code: 'UKN', name: 'Northern Ireland'}
]

regions.each do |region|
  record = Region.where(nuts_code: region[:nuts_code]).first || Region.new
  record.nuts_code = region[:nuts_code]
  record.name = region[:name]
  record.save!
end


policy_areas = [
  {name: "Communities"},
  {name: "Housing"},
  {name: "Jobs and growth"},
  {name: "Homelessness and Rough Sleeping"},
  {name: "Local economies"},
  {name: "Local government"},
  {name: "Local resilience"},
  {name: "Local service delivery"}
]
policy_areas.each do |policy_area|
  record = PolicyArea.find_or_create_by(name: policy_area[:name])
end

role_types = [
  {name: 'C-level Executive'}
]
role_types.each do |role_type|
  record = RoleType.find_or_create_by(name: role_type[:name])
end
