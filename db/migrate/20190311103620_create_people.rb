class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :slug, unique: true
      t.string :title

      t.timestamps
    end
  end
end
