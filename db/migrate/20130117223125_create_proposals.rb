class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :vendor_id
      t.integer :quotation_id
      t.string :document
      t.text :description
      t.date :date
      t.string :validity

      t.timestamps
    end
  end
end
