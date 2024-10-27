class CreateMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :matches, id: :uuid do |t|
      t.date :date, null: false
      t.string :match_result, null: false
      t.string :score, null: false

      t.timestamps
    end
  end
end
