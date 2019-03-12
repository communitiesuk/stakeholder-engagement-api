class CreateEngagementPolicyAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :engagement_policy_areas do |t|
      t.references :engagement, foreign_key: true
      t.references :policy_area, foreign_key: true

      t.timestamps
    end
  end
end
