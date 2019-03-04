class OrganisationType < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name,  uniqueness: true,
                    presence: true,
                    length: {minimum: 2, maximum: 64}
end
