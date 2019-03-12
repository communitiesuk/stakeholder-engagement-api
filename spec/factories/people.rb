FactoryBot.define do
  factory :person do
    name { "Joe Bloggs" }
    title { "Mr" }

    factory :recorded_by do
      name { 'Bill Willis' }
    end

    factory :stakeholder do
      name { 'Jane Doe' }
      title { 'Dame'}

      transient do
        roles_count { 1 }
      end

      after(:create) do |person, evaluator|
        evaluator.roles_count.times do |i|
          create(:role, title: "role #{i}", region: nil, person: person)
        end
      end
    end
  end

end
