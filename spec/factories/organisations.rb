FactoryBot.define do
  factory :organisation do
    name { "My Local Authority" }
    slug { "my-local-authority" }
    association :organisation_type
    association :region
  end
end
