# frozen_string_literal: true

class Match < ApplicationRecord
  include SharedModelMethods

  belongs_to :team

  has_many :participations, dependent: :destroy
  has_many :players, through: :participations

  accepts_nested_attributes_for :participations, allow_destroy: true

  validates :date, :team, presence: true
  validates :score, presence: true, unless: -> { new_record? }

  after_update :update_goals_conceded

  scope :by_year, ->(year) {
    return all unless year.present?

    where(date: Date.new(year).beginning_of_year..Date.new(year).end_of_year)
  }

  scope :by_date, ->(date) {
    date.present? ? where(date: date).order(date: :desc) : order(date: :desc)
  }

  private

  def match_year
    @match_year ||=date.year.to_s
  end

  def update_goals_conceded
    return unless (scores_hash = previous_changes[:score]).present?

    previous_score = scores_hash.first.split('x').map(&:to_i)
    new_score = scores_hash.last.split('x').map(&:to_i)

    participations = Participation.where(player: players.goalkeeper, match: self).as_goalkeeper
    participations.each do |participation|
      old_goals = case
      when participation.victory? then previous_score.min
      when participation.draw? then previous_score[0]
      else previous_score.max
      end

      new_goals = case
      when participation.victory? then new_score.min
      when participation.draw? then new_score[0]
      else new_score.max
      end

      participation.player.goals_conceded[match_year] ||= 0
      participation.player.goals_conceded[match_year] -= old_goals if old_goals
      participation.player.goals_conceded[match_year] += new_goals
      participation.player.update_column(:goals_conceded, participation.player.goals_conceded)
    end
  end

  def self.create_matches_for_sundays(year = Time.zone.now.year, current_user = nil)
    raise 'No current user passed' unless current_user.present?

    first_day_of_year = Date.new(year).beginning_of_year
    last_day_of_year = Date.new(year).end_of_year

    sundays = (first_day_of_year..last_day_of_year).select(&:sunday?)

    sundays.each do |sunday|
      Match.create!(date: sunday, score: '')
    end

    puts "#{sundays.count} success to create matches for all sundays at #{year}!"
  end

  def self.max_score
    fetch_scores.max_by { |num, _| num }&.last
  end

  def self.min_score
    fetch_scores.min_by { |num, _| num }&.last
  end

  def self.fetch_scores
    # TODO: Implementar cache com Redis
    # Rails.cache.fetch('scores_cache', expires_in: 20.minutes) do
    #   pluck(:score).compact_blank.each_with_object({}) do |score, memo|
    #     numeric_score = score.gsub(/\D/, '').to_i
    #     memo[numeric_score] = score
    #   end
    # end
    pluck(:score).compact_blank.each_with_object({}) do |score, memo|
      numeric_score = score.gsub(/\D/, '').to_i
      memo[numeric_score] = score
    end
  end
end
