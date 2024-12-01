# frozen_string_literal: true

module Api
  module V1
    class ClassificationController < ApiV1ApplicationController
      before_action :set_team, only: :show

      def show
        team = set_team
        return render json: { error: 'Equipe n o encontrada' }, status: :not_found unless team

        players = team.players.map do |player|
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

        top_scorers = team.players.top_scorers.map do |player|
          { name: player[0], goals: player[1] }
        end

        render json: {
          data: players.sort_by { |hash| -hash[:statistics][:performance_percentage] },
          top_scorers: top_scorers
        }
      end

      private

      def load_participations
        @load_participations ||= set_team.participations
      end

      def set_team
        @set_team ||= Team.find_by_slug(params[:slug])
      end
    end
  end
end
