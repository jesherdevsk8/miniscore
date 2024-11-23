# frozen_string_literal: true

module Api
  module V1
    class ClassificationController < ApiV1ApplicationController
      def index
        classifications = Player.includes(:participations).map do |player|
          {
            name: player.name,
            statistics: {
              total_goals: player.total_goals,
              total_matches: player.total_matches,
              victories: player.vitorias,
              defeats: player.derrotas,
              draws: player.empates,
              average_goals_per_match: player.goals_per_matches,
              performance_percentage: player.percentage,
              last_five_participations: player.last_five_participations
            }
          }
        end

        top_scorers = Player.top_scorers.map do |player|
          { name: player[0], goals: player[1] }
        end

        render json: {
          data: classifications.sort_by { |hash| -hash[:statistics][:performance_percentage] },
          top_scorers: top_scorers
        }
      end
    end
  end
end
