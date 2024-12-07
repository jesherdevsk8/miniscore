# frozen_string_literal: true

module Api
  module V1
    class TeamsController < ApiV1ApplicationController
      def index
        teams = Team.order(:created_at).map do |team|
          {
            name: team.name,
            slug: team.slug,
            description: team.description,
            created_at: team.created_at.iso8601
          }
        end

        render json: { data: teams }
      end
    end
  end
end
