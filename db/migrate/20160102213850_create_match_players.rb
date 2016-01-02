class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|
      t.integer :player_id
      t.integer :match_id
      t.integer :champion_id

      t.timestamps null: false
    end
  end
end
