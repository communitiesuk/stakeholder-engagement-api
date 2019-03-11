FactoryBot.define do
  factory :role do
    title { "CDO" }
    association :organisation
    association :person
    association :role_type
    association :region
  end
end
