class Participation < ApplicationRecord
  belongs_to :player
  belongs_to :match

  validates :goals, numericality: { greater_than_or_equal_to: 0 }
end
