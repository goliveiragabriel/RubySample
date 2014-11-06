class CreateMerits < ActiveRecord::Migration
  def change
    create_table :merits do |t|
      t.string :merits_type

      t.timestamps
    end
  end
end
