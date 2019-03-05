class Region < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :nuts_code, presence: true,
                        uniqueness: true,
                        length: {minimum: 3, maximum: 4}
  validates :name,      presence: true,
                        uniqueness: true,
                        length: {minimum: 2, maximum: 64}

end
