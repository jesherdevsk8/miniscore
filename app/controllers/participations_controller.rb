# frozen_string_literal: true

class ParticipationsController < ApplicationController
  before_action :set_participation, only: %i[ show edit update destroy ]
  before_action :match_results, only: %i[ new create edit ]
  before_action :select_options, only: %i[ new create edit ]

  # GET /participations or /participations.json
  def index
    @participations = Participation.includes(:player, :match)
                                   .order(created_at: :desc)
  end

  # GET /participations/1 or /participations/1.json
  def show
  end

  # GET /participations/new
  def new
    @participation = Participation.new
    @participation.build_match
  end

  # GET /participations/1/edit
  def edit
  end

  # POST /participations or /participations.json
  def create
    @participation = Participation.new(participation_params)

    respond_to do |format|
      if @participation.save
        format.html { redirect_to edit_participation_path(@participation), notice: 'Participação criada com sucesso.' }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { render :new, status: :unprocessable_entity, alert: 'Houve um erro ao criar a participação.' }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participations/1 or /participations/1.json
  def update
    respond_to do |format|
      if @participation.update(participation_params)
        format.html { redirect_to @participation, notice: 'Participação atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @participation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1 or /participations/1.json
  def destroy
    @participation.destroy!

    respond_to do |format|
      format.html { redirect_to participations_path, status: :see_other, notice: 'Participação deletada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  def match_results
    @match_results ||= Participation.results
  end

  def select_options
    @players_select ||= Player.pluck(:name, :id)
    @matches_select ||= Match.pluck(:date, :id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_participation
    @participation = Participation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def participation_params
    params.require(:participation).permit(:player_id, :goals, :match_id, :match_result)
  end
end
