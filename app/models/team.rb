# frozen_string_literal: true

class Team < ApplicationRecord
  include SharedModelMethods

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user

  has_many :participations, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :matches, dependent: :destroy

  validates :name, :slug, :user, presence: true
  validates :name, :slug, uniqueness: true

  def goalkeepers
    players.goalkeeper
  end

  def valid_matches
    current_time = Time.current
    first_day_of_year = Date.new(current_time.year).beginning_of_year

    matches.where(date: first_day_of_year..current_time.to_date)
           .order(date: :desc).pluck(:date, :id)
  end

  def get_players(current_year = Time.current.year)
    players.order(:name).participations_by_year(current_year).map do |player|
      {
        name: player.name,
        statistics: {
          total_matches: player.total_matches(current_year),
          victories: player.vitorias(current_year),
          defeats: player.derrotas(current_year),
          draws: player.empates(current_year),
          performance_percentage: player.percentage(current_year),
          last_five_participations: player.last_five_participations(current_year)
        }
      }
    end
  end

  def get_top_scorers(current_year = Time.current.year)
    # TODO: players name em ordem alfabetica
    players.order(:name).participations_by_year(current_year).top_scorers(current_year).map do |player|
      { name: player[0], goals: player[1], average_goals_per_match: player[2] }
    end
  end

  def least_conceded_goalkeepers(current_year = Time.current.year)
    # TODO: Implementar Rails cache para melhorar o desempenho
    goalkeepers.order(:name).participations_by_year(current_year)
               .sort_by { |player| player.goals_conceded[current_year.to_s] || 0 }
               .map { |player| { name: player.name, goals: player.goals_conceded[current_year.to_s] || 0,
                                 average_goals_conceded_per_match: player.average_goals_conceded_per_match(current_year) || 0,
                                 total_matches: player.total_goalkeeper_matches(current_year) || 0 } }
  end
end
