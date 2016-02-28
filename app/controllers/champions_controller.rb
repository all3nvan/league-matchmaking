class ChampionsController < ApplicationController
  def index
    @champions = Champion.new.all_champion_stats
  end
end
