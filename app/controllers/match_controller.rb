class MatchController < ApplicationController
  def index
    @matches = Match.order(:time).all
  end
end
