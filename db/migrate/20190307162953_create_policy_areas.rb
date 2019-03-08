class CreatePolicyAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_areas do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
