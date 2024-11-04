class HomeController < ApplicationController
  def index
    @total_matches = Match.count
    @total_players = Player.count
    @total_goals   = Participation.sum(:goals)
    # flash[:notice] = 'Login efetuado com sucesso!'
    # flash[:info] = 'Você tem mensagens não visualizadas'
    # flash[:warning] = 'País deve ser selecionado'
    # flash[:error] = 'Não foi possível encontrar o imóvel'
  end
end
