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
  end
end
