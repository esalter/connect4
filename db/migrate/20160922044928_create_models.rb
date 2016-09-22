class CreateModels < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string :difficulty, null: false
      t.integer :first_player, null: false
      t.integer :rows, null: false
      t.integer :columns, null: false
    end
    create_table :moves do |t|
      t.integer :game_id, :null => false, :references => [:games, :id]
      t.integer :player, null: false
      t.integer :column, null: false
    end
  end

  def down
    drop_table :moves
    drop_table :games
  end
end