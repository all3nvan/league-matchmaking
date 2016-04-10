json.players @players do |player|
  json.(player, :id, :name)
end
