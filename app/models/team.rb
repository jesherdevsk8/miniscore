# frozen_string_literal: true

class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user

  has_many :participations
  has_many :players
  has_many :matches

  validates :name, :slug, :user, presence: true
  validates :name, :slug, uniqueness: true

  def get_valid_matches
    current_time = Time.current
    first_day_of_year = Date.new(current_time.year).beginning_of_year
    last_day_of_year = Date.new(current_time.year).end_of_year

    matches.where(date: first_day_of_year..last_day_of_year).pluck(:date, :id)
  end
end
