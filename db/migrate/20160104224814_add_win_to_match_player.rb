class AddWinToMatchPlayer < ActiveRecord::Migration
  def change
    add_column :match_players, :win, :boolean
  end
end
