# frozen_string_literal: true

class Team < ApplicationRecord
  include SharedModelMethods

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user

  has_many :participations
  has_many :players
  has_many :matches

  validates :name, :slug, :user, presence: true
  validates :name, :slug, uniqueness: true

  def get_players(current_year = Time.current.year)
    players.participations_by_year(current_year).map do |player|
      {
        name: player.name,
        statistics: {
          total_goals: player.total_goals(current_year),
          total_matches: player.total_matches(current_year),
          victories: player.vitorias(current_year),
          defeats: player.derrotas(current_year),
          draws: player.empates(current_year),
          average_goals_per_match: player.goals_per_matches(current_year),
          performance_percentage: player.percentage(current_year),
          last_five_participations: player.last_five_participations(current_year)
        }
      }
    end
  end

  def get_top_scorers(current_year = Time.current.year)
    players.participations_by_year(current_year).top_scorers(current_year).map do |player|
      { name: player[0], goals: player[1] }
    end
  end

  def get_players(current_year = Time.current.year)
    players.participations_by_year(current_year).map do |player|
      {
        name: player.name,
        statistics: {
          total_goals: player.total_goals(current_year),
          total_matches: player.total_matches(current_year),
          victories: player.vitorias(current_year),
          defeats: player.derrotas(current_year),
          draws: player.empates(current_year),
          average_goals_per_match: player.goals_per_matches(current_year),
          performance_percentage: player.percentage(current_year),
          last_five_participations: player.last_five_participations(current_year)
        }
      }
    end
  end

  def get_top_scorers(current_year = Time.current.year)
    players.participations_by_year(current_year).top_scorers(current_year).map do |player|
      { name: player[0], goals: player[1] }
    end
  end
end
