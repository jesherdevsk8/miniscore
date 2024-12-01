class HomeController < ApplicationController
  def index
    @total_matches = load_matches.count
    @total_players = load_players.count
    @total_goals   = load_participations.sum(:goals)
    @top_scorer   = load_players.top_scorers(max_by: true, sort_by: false)
  end
end
