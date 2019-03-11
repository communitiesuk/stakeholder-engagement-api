class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name,      presence: true,
                        uniqueness: false,
                        length: {minimum: 2, maximum: 256}

end
