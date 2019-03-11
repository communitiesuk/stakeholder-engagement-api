class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string     :slug, index: true
      t.string     :title, index: true
      t.references :person, foreign_key: true
      t.references :organisation, foreign_key: true
      t.references :region, foreign_key: true, null: true
      t.references :role_type, foreign_key: true

      t.timestamps
    end
    add_index :roles, [:person_id, :organisation_id, :region_id, :title],
                      name: 'ix_role_unique_person_org_region_title',
                      unique: true
  end
end
