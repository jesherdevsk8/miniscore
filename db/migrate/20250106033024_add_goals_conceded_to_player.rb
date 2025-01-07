class AddGoalsConcededToPlayer < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :goals_conceded, :integer, default: 0
  end
end
