class AddRelationTeamToMatch < ActiveRecord::Migration[7.2]
  def change
    add_reference :matches, :team, foreign_key: true
  end
end
