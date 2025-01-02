# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @total_matches = load_matches.count
    @total_players = load_players.count
    @total_goals   = load_participations.sum(:goals)
    @top_scorer    = load_players.top_scorers(max_by: true, sort_by: false)
    @max_score     = load_matches.max_score
    @min_score     = load_matches.min_score
    # TODO: Fazer calculo de empates, adicionar uma coluna resultado tbm na partida
    # @total_draws   = load_participations.draw.size
  end
end
