class CreateRoleTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :role_types do |t|
      t.string :name, unique: true
      t.string :slug, unique: true

      t.timestamps
    end
  end
end
