# frozen_string_literal: true

class Player < ApplicationRecord
  include SharedModelMethods

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :team

  has_many :participations
  has_many :matches

  validates :name, :number, :team, presence: true
  validates :position, presence: true

  enum position: { goalkeeper: 'goleiro', field: 'linha' }

  scope :by_slug, ->(slug) { slug.present? ? where(slug: slug) : order(:id) }

  def total_goals(year = nil)
    participations.by_year(year).sum(:goals)
  end

  def self.top_scorers(year = nil, max_by: false, sort_by: true)
    # TODO: Otimizar esse metodo
    players = self.all.map do |player|
      [ player.name, player.participations.by_year(year).sum(:goals) ]
    end

    players = players.sort_by { |_, goals| -goals } if sort_by
    players = players.reject { |_, goals| goals.zero? }.max_by { |_, goals| goals } if max_by

    players
  end

  def total_matches(year = nil)
    @total_matches ||= participations.by_year(year).size
  end

  def vitorias(year = nil)
    participations.by_year(year).victory.size
  end

  def empates(year = nil)
    participations.by_year(year).draw.size
  end

  def derrotas(year = nil)
    participations.by_year(year).defeat.size
  end

  def goals_per_matches(year = nil)
    total_matches = total_matches(year)
    return 0 if total_matches.zero?
    (total_goals(year).to_f / total_matches)&.round(2)
  end

  def percentage(year = nil)
    total_matches = total_matches(year)
    return 0 if total_matches.zero?
    ((vitorias(year) * 3 + empates(year)).to_f / (total_matches * 3) * 100).round
  end

  def last_five_participations(year = nil)
    participations.by_year(year).map { |part| part.match_result }.last(5)
  end

  # Opcional: Atualiza o slug se o nome mudar
  def should_generate_new_friendly_id?
    name_changed?
  end
end
