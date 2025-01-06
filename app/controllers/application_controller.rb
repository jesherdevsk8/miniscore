# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_user_team

  private

  def current_user_team
    @current_user_team ||= Team.includes(:matches, :participations, :players)
                               .find_by_id(current_user&.team&.id)
  end

  def load_matches
    @load_matches ||= current_user_team&.matches
  end

  def load_participations
    @load_participations ||= current_user_team&.participations
  end

  def load_players
    @load_players ||= current_user_team&.players
  end

  def match_results
    @match_results ||= Participation.results
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[team_name name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[team_name name])
  end
end
