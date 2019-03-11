class Role < ApplicationRecord
  belongs_to :person
  belongs_to :organisation
  belongs_to :region, optional: true
  belongs_to :role_type

  extend FriendlyId
  friendly_id :title, use: :slugged


  validates :title, length: {minimum: 2, maximum: 128},
                    presence: true,
                    uniqueness: {
                      scope: [:person_id, :organisation_id, :region_id]
                    }

end
