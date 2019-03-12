class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :roles
  has_many :organisations, through: :roles

  validates :name,      presence: true,
                        uniqueness: false,
                        length: {minimum: 2, maximum: 256}

  include PgSearch
  pg_search_scope :search,
                  against: [ :name, :title ],
                  associated_against: {
                    organisations: [:name],
                    roles: [:title]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def role_titles
    roles.map(&:title)
  end

  def organisation_names
    roles.map{|role| role.organisation.name}
  end
end
