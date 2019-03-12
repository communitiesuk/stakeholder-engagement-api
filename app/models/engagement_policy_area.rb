class EngagementPolicyArea < ApplicationRecord
  belongs_to :engagement
  belongs_to :policy_area

  validates :engagement_id,   presence: true
  validates :policy_area_id,  presence: true,
                              uniqueness: { scope: [:engagement_id] }

end
