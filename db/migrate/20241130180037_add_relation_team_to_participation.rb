class AddRelationTeamToParticipation < ActiveRecord::Migration[7.2]
  def change
    add_reference :participations, :team, foreign_key: true
  end
end
