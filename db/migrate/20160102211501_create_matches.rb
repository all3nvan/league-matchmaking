class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :match_id
      t.integer :time

      t.timestamps null: false
    end
  end
end
