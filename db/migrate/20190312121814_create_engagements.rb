class CreateEngagements < ActiveRecord::Migration[5.2]
  def change
    create_table :engagements do |t|
      t.boolean :anonymous
      t.date :contact_date
      t.boolean :contact_made
      t.text :summary
      t.string :notes
      t.text :next_steps
      t.boolean :escalated
      t.boolean :email_receipt
      t.string :next_planned_contact

      t.references :stakeholder, index: true, foreign_key: {to_table: :people}
      t.references :recorded_by, index: true, foreign_key: {to_table: :people}

      t.timestamps
    end
  end
end
