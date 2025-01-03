# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :set_years, only: :index

  def index
    # TODO: Usar cache com Redis
    year = params[:year].present? ? Date.new(params[:year].to_i).year : Time.current.year

    @total_matches = load_matches.participations_by_year(year).size
    @total_players = load_players.count
    @total_goals   = load_participations.by_year(year).sum(:goals)
    @top_scorer    = load_players.top_scorers(year, max_by: true, sort_by: false)
    @max_score     = load_matches.by_year(year).max_score
    @min_score     = load_matches.by_year(year).min_score
    # TODO: Fazer calculo de empates, adicionar uma coluna resultado tbm na partida
    # @total_draws   = load_participations.by_year(year).draw.size
  end

  private

  def set_years
    @years ||= load_matches.select('DISTINCT EXTRACT(YEAR FROM date) AS year')
                           .map { |match| match.year.to_i }
  end
end
