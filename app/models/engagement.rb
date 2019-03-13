class Engagement < ApplicationRecord
  belongs_to :stakeholder, class_name: 'Person'
  belongs_to :recorded_by, class_name: 'Person'

  has_many :engagement_policy_areas
  has_many :policy_areas, through: :engagement_policy_areas


  def slug
    id
  end

end
