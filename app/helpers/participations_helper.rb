# frozen_string_literal: true

module ParticipationsHelper
  def match_result(participation)
    if participation.victory?
      '<i class="bi bi-check-circle-fill text-success"> Vitória </i>'.html_safe
    elsif participation.draw?
      '<i class="bi bi-dash-circle-fill text-secondary"> Empate </i>'.html_safe
    elsif participation.defeat?
      '<i class="bi bi bi-x-circle-fill text-danger"> Derrota </i>'.html_safe
    else
      '<i class="bi bi-circle-fill text-warning"> ???? </i>'.html_safe
    end
  end
end
