json.players @players do |player|
  json.(player, :id, :name, :wins, :losses, :trueskill)
end
