class PolicyArea < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name,      presence: true,
                        uniqueness: true,
                        length: {minimum: 2, maximum: 64}
end
