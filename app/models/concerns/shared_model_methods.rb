# frozen_string_literal: true

module SharedModelMethods
  extend ActiveSupport::Concern

  included do
    scope :participations_by_year, ->(year) {
      return all unless year.present?

      joins(:participations).where(
        participations: { created_at: Time.new(year).beginning_of_year..Time.new(year).end_of_year }
      ).distinct
    }
  end

  class_methods do
    def valid_matches
      current_time = Time.current
      first_day_of_year = Date.new(year).beginning_of_year

      if self.class.name == 'Team'
        matches.where(date: first_day_of_year..current_time.to_date).pluck(:date, :id)
      elsif self.class.name == 'Match'
        where(date: first_day_of_year..current_time.to_date).pluck(:date, :id)
      else
        []
      end
    end
  end
end
