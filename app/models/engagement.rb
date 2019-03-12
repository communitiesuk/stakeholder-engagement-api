class Engagement < ApplicationRecord
  belongs_to :stakeholder, class_name: 'Person'
  belongs_to :recorded_by, class_name: 'Person'


  def slug
    id
  end

end
