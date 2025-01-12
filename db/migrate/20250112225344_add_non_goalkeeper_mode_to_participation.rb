class AddNonGoalkeeperModeToParticipation < ActiveRecord::Migration[7.2]
  def change
    add_column :participations, :non_goalkeeper_mode, :boolean, default: false
  end
end
