FactoryBot.define do
  factory :engagement_policy_area do
    association :engagement
    association :policy_area
  end
end
