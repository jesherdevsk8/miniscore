# frozen_string_literal: true

class Player < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :team

  has_many :participations
  has_many :matches

  validates :name, :number, :team, presence: true

  def total_goals
    participations.sum(:goals)
  end

  def self.top_scorers(max_by: false, sort_by: true)
    players = Player.all.map do |player|
      [ player.name, player.participations.sum(:goals) ]
    end

    players = players.sort_by { |_, goals| -goals } if sort_by
    players = players.max_by { |_, goals| goals } if max_by

    players
  end

  def total_matches
    @total_matches ||= participations.size
  end

  def vitorias
    participations.where(match_result: 'vitoria').size
  end

  def empates
    participations.where(match_result: 'empate').size
  end

  def derrotas
    participations.where(match_result: 'derrota').size
  end

  def goals_per_matches
    return 0 if total_matches.zero?
    (total_goals.to_f / total_matches)&.round(2)
  end

  def percentage
    return 0 if total_matches.zero?
    ((vitorias * 3 + empates).to_f / (total_matches * 3) * 100).round
  end

  def last_five_participations
    participations.map { |part| part.match_result }.last(5)
  end

  # Opcional: Atualiza o slug se o nome mudar
  def should_generate_new_friendly_id?
    name_changed?
  end
end
