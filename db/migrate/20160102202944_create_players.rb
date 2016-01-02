class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :summoner_id
      t.float :rating
      t.float :standard_deviation

      t.timestamps null: false
    end
  end
end
