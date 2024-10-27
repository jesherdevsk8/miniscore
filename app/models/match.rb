class Match < ApplicationRecord
  has_many :participations
  has_many :players, through: :participations

  validates :date, presence: true
  validates :match_result, presence: true, inclusion: { in: %w[vitoria empate derrota] }
end
