# frozen_string_literal: true

module Api
  module V1
    class ClassificationController < ApiV1ApplicationController
      before_action :set_team, only: :show

      def show
        team = set_team
        return render json: { error: 'Equipe não encontrada' }, status: :not_found unless team

        year = params[:year].present? ? Date.new(params[:year].to_i).year : Time.current.year
        players = team.get_players(year)
        top_scorers = team.get_top_scorers(year)
        least_conceded_goalkeepers = team.least_conceded_goalkeepers(year).sort_by do |hash|
          [ hash[:average_goals_conceded_per_match], hash[:name] ]
        end

        render json: { data: players.sort_by { |hash| [ -hash[:statistics][:performance_percentage], hash[:name] ] },
                       top_scorers: top_scorers, least_conceded_goalkeepers: least_conceded_goalkeepers }
      end

      private

      def set_team
        @set_team ||= Team.find_by_slug(params[:slug])
      end
    end
  end
end
