# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]
  before_action :match_results, only: %i[ new create edit ]
  before_action :matches_options, :set_years, only: :index

  # GET /matches or /matches.json
  def index
    @pagy, @matches = pagy(load_matches.by_date(params[:date]))
  end

  # GET /matches/1 or /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = load_matches.new
    load_players.order(:name)
                .each { |player| @match.participations.build(player: player) }
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches or /matches.json
  def create
    @match = load_matches.new(match_params)

    respond_to do |format|
      if @match.save
        flash[:notice] = 'Partida criada com sucesso!'
        format.html { redirect_to @match }
        format.json { render :show, status: :created, location: @match }
      else
        flash[:error] = @match.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        flash[:notice] = 'Partida atualizada com sucesso!'
        format.html { redirect_to @match }
        format.json { render :show, status: :ok, location: @match }
      else
        flash[:error] = @match.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy!

    respond_to do |format|
      flash[:notice] = 'Partida deletada com sucesso!'
      format.html { redirect_to matches_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def matches_options
    year = params[:year].present? ? Date.new(params[:year].to_i).year : Time.current.year

    # TODO: Try use redis cache
    @matches_options ||= load_matches.by_year(year).order(date: :desc).distinct.pluck(:date)
                                     .map { |date| [ date.strftime('%d/%m/%Y'), date ] }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = load_matches.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:date, :score,
      participations_attributes: [
        :id,
        :player_id,
        :match_result,
        :goals,
        :_destroy
      ]
    )
  end
end
