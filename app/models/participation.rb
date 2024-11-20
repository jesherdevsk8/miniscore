class Participation < ApplicationRecord
  belongs_to :player
  belongs_to :match

  enum :match_result, victory: 'vitoria', draw: 'empate', defeat: 'derrota', _prefix: true
  # match_result_victory!, match_result_draw!, e match_result_defeat!

  validates :goals, numericality: { greater_than_or_equal_to: 0 }
  validates :match_result, presence: true

  def self.results
    match_results.except('_prefix').invert.map { |k, v| [ k.humanize, v ] }
  end
end
