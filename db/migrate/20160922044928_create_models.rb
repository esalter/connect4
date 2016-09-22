class CreateModels < ActiveRecord::Migration
  def up
    create_table :games do |t|
    end
    create_table :moves do |t|
      t.integer :game_id, :null => false, :references => [:games, :id]
      t.integer :sequence
      t.integer :player
      t.integer :column
      t.string :difficulty
    end
  end

  def down
    drop_table :moves
    drop_table :games
  end
end