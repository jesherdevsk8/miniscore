class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name, null: false
      t.integer :number, null: false
      t.string :slug, null: false
      t.string :nickname

      t.timestamps
    end

    add_index :players, :slug, unique: true
  end
end
