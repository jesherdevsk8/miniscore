# frozen_string_literal: true

class Match < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :players, through: :participations

  accepts_nested_attributes_for :participations, allow_destroy: true

  validates :date, presence: true
  validates :score, presence: true, unless: -> { new_record? }

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
end
