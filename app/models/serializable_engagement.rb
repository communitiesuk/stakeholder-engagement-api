class SerializableEngagement < JSONAPI::Serializable::Resource
  type :engagements
  belongs_to :stakeholder, class_name: 'person'
  belongs_to :recorded_by, class_name: 'person'

  attributes :id,
             :anonymous,
             :contact_date,
             :contact_made,
             :summary,
             :notes,
             :next_steps,
             :escalated,
             :email_receipt,
             :next_planned_contact,
             :stakeholder_id,
             :recorded_by_id,
             :created_at,
             :updated_at

  link :self do
    @url_helpers.api_v1_engagement_path(@object.id)
  end
end
