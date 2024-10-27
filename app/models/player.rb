class Player < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :participations
  has_many :matches

  validates :name, :number, presence: true

  def total_goals
    participations.sum(:goals)
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

  # Opcional: Atualiza o slug se o nome mudar
  def should_generate_new_friendly_id?
    name_changed?
  end
end
