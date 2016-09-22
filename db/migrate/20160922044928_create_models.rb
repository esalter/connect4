class CreateModels < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string :difficulty
    end
    create_table :moves do |t|
      t.integer :game_id, :null => false, :references => [:games, :id]
      t.integer :player
      t.integer :column
    end
  end

  def down
    drop_table :moves
    drop_table :games
  end
end