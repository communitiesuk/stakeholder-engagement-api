class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :slug, unique: true
      t.string :nuts_code, unique: true
      t.string :name, unique: true

      t.timestamps
    end
  end
end
