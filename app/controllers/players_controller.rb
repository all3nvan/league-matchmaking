class PlayersController < ApplicationController
  def index
    @players = Player.all.sort_by(&:trueskill).reverse
  end

  def show
    @player = Player.find(params[:id])
  end
end
