# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]
  before_action :players_options, only: :index
  before_action :positions_options, only: %i[new create edit update]

  # GET /players or /players.json
  def index
    players = load_players.by_slug(params[:slug])
    @pagy, @players = pagy(players)
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = load_players.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = load_players.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Jogador criado com sucesso.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Jogador atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    return render_json(status: :forbidden) if @player.participations.any?

    @player.destroy!
    render_json(status: :ok)
  end

  private

  def render_json(status: :ok)
    message = status == :ok ? 'Jogador deletado com sucesso.' : 'Jogador possui participações.'
    flash[:error] = message if status == :forbidden
    flash[:notice] = message if status == :ok

    respond_to do |format|
      format.html { redirect_to players_path, status: :see_other, notice: message }
      format.json { head :no_content }
    end
  end

  def positions_options
    @positions_options ||= Player.positions.invert.to_a
  end

  def players_options
    @players_options ||= load_players.pluck(:name, :slug)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = load_players.friendly.find_by_slug(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def player_params
    params.require(:player).permit(:name, :number, :slug, :nickname, :position)
  end
end
