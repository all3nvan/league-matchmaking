class MatchmakingController < ApplicationController
  def new
    @players = Player.order(:name).all
  end

  def create
    selected_players = params['selected_players']

    if selected_players && selected_players.size == 10
      @selected_player_ids = selected_players.map(&:to_i)
      render :show
    else
      flash[:notice] = "Please select 10 players"
      redirect_to new_matchmaking_path
    end
  end
end
