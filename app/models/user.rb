# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :team_name

  has_one :team, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, uniqueness: true, format: { with: /\A.+@.+\..+\z/ }

  after_create :create_team

  private

  def create_team
    self.team_name = generate_team_name

    Team.create!(name: self.team_name, user: self)
  end

  def generate_team_name
    if load_teams.values.include?(self.team_name) || team_name.blank?
      "#{self.email.split('@')[0]}-team-#{SecureRandom.uuid[0..7]}"
    else
      self.team_name
    end
  end

  def load_teams
    @load_teams ||= Team.pluck(:id, :name).to_h
  end
end
