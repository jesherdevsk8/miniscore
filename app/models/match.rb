class Match < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :players, through: :participations

  accepts_nested_attributes_for :participations, allow_destroy: true

  validates :date, :score, presence: true
end
