class CreateParticipations < ActiveRecord::Migration[7.2]
  def change
    create_table :participations, id: :uuid do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :match, null: false, foreign_key: true, type: :uuid
      t.integer :goals, default: 0

      t.timestamps
    end
  end
end
