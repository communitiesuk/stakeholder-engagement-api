class Organisation < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :organisation_type
  belongs_to :region, optional: true

  validates :name,      presence: true,
                        uniqueness: {scope: [:region, :organisation_type]},
                        length: {minimum: 2, maximum: 64}
end
