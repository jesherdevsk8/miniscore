# frozen_string_literal: true

class Match < ApplicationRecord
  include SharedModelMethods

  belongs_to :team

  has_many :participations, dependent: :destroy
  has_many :players, through: :participations

  accepts_nested_attributes_for :participations, allow_destroy: true

  validates :date, :team, presence: true
  validates :score, presence: true, unless: -> { new_record? }

  scope :by_year, ->(year) {
    return all unless year.present?

    where(date: Date.new(year).beginning_of_year..Date.new(year).end_of_year)
  }

  scope :by_date, ->(date) { date.present? ? where(date: date) : order(date: :desc) }

  private

  def self.create_matches_for_sundays(year = Time.zone.now.year)
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
