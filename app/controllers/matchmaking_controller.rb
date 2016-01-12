class MatchmakingController < ApplicationController
  def new
    @players = Player.order(:name).all
  end

  def create
    @selected_player_ids = params.select { |k, v| v == 'selected' }.keys.map(&:to_i)

    if @selected_player_ids.size == 10
      render inline: "<%= @selected_player_ids %>"
    else
      flash[:notice] = "Please select 10 players"
      redirect_to new_matchmaking_path
    end
  end
end
