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
    # Metodos aqui
  end
end
