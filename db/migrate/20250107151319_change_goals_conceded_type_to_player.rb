# frozen_string_literal: true

class ChangeGoalsConcededTypeToPlayer < ActiveRecord::Migration[7.2]
  def up
    add_column :players, :goals_conceded_jsonb, :jsonb, default: {}

    Player.reset_column_information
    Player.find_each do |player|
      next unless player.goals_conceded

      transformed_data = transform_goals_conceded(player.goals_conceded)
      player.update_columns(goals_conceded_jsonb: transformed_data)
    end

    remove_column :players, :goals_conceded, :integer

    rename_column :players, :goals_conceded_jsonb, :goals_conceded
  end

  def down
    add_column :players, :goals_conceded_integer, :integer

    Player.reset_column_information
    Player.find_each do |player|
      next unless player.goals_conceded

      total_goals = player.goals_conceded.values.sum
      player.update_columns(goals_conceded_integer: total_goals)
    end

    remove_column :players, :goals_conceded, :jsonb

    rename_column :players, :goals_conceded_integer, :goals_conceded
  end

  private

  def transform_goals_conceded(old_data)
    { Time.current.year => old_data }
  end
end
