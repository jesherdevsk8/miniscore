class AddPositionToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :position, :string
  end
end
