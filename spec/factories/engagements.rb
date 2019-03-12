FactoryBot.define do
  factory :engagement do
    association :stakeholder
    association :recorded_by
    contact_date { (Time.now - 1.day).to_date }
    contact_made { true }
    summary { "Talked urbanely on various matters of the day" }
    notes { "blog link: https://example.com/my-blog" }
    next_steps { "Follow up on 2 weeks" }
    escalated { false }
    email_receipt { true }
    next_planned_contact { "2-4 weeks" }

    factory :engagement_with_policy_areas do
      transient do
        policy_areas_count { 1 }
      end

      after(:create) do |engagement, evaluator|
        evaluator.policy_areas_count.times do |i|
          create(:engagement_policy_area, engagement: engagement, policy_area: policy_area)
        end
      end
    end
  end
end
