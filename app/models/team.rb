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
end
