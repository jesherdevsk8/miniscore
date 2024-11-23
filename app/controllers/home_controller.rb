class HomeController < ApplicationController
  def index
    @total_matches = Match.count
    @total_players = Player.count
    @total_goals   = Participation.sum(:goals)
    @top_scorer   = Player.top_scorer
  end
end
