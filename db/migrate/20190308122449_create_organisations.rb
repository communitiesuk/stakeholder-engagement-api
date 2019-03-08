class CreateOrganisations < ActiveRecord::Migration[5.2]
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :slug
      t.references :organisation_type, foreign_key: true
      t.references :region, null: true, foreign_key: true

      t.timestamps
    end
  end
end
