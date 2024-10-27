class Player < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :participations
  has_many :matches

  validates :name, :number, presence: true

  def total_goals
    participations.sum(:goals)
  end

  def all_participations
    participations.count
  end

  def vitorias
    participations.joins(:match).where(matches: { match_result: 'vitoria' }).count
  end

  def empates
    participations.joins(:match).where(matches: { match_result: 'empate' }).count
  end

  def derrotas
    participations.joins(:match).where(matches: { match_result: 'derrota' }).count
  end

  def goals_per_matches
    return 0 if all_participations.zero?
    total_goals.to_f / all_participations
  end

  # Opcional: Atualiza o slug se o nome mudar
  def should_generate_new_friendly_id?
    name_changed?
  end
end
