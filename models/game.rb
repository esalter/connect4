class Game < ActiveRecord::Base
  has_many :moves, -> { order(:id) }
  after_initialize :create_state_data
  after_find :recreate_state

  # sets a token in the game board.  if update_db is true,
  # then also create the move in the db.
  # useful if we are loading from the db and just want to
  # reconstruct the game
  def place_token(player, column, update_db = true)
    if player == current_player
      # find the first free slot.
      row = 0
      begin
        if @state[row][column] == ''
          @state[row][column] = player
          create_move player, column if update_db
          set_next_player
          return true
        end
        row += 1
      end until row >= self.rows
    end

    false
  end

  def create_move(player, column)
    Move.create(player: player, column: column, game_id: self.id)
  end

  def next_player
    @current_player == 1 ? 2 : 1
  end

  def set_next_player
    @current_player = next_player
  end

  def current_player
    @current_player
  end

  # gets the tokens (or blanks) in a column, starting from the bottom.
  def get_column(index)
    column = []
    self.rows.times do |i|
      column.push(@state[i][index])
    end

    column
  end

  def to_json(options = {})
    # we keep the state in a "reversed" manner (bottom-up) to keep things a bit easier to calculate
    # but we don't want to expose that to the consuming code which expects left-right top-down
    # interpretation.
    JSON.pretty_generate({state: @state.reverse, game_id: self.id}, options)
  end

  protected
  @initialized = false
  def create_state_data

    # since after_find happens before after_initialization, and we need to cover
    # the case where we are creating or finding a record, we need this
    # check for if we've already initialized.
    if !@initialized
      @state = []

      @current_player = self.first_player
      self.rows.times do |i|
        @state.push([])
        self.columns.times do |j|
          val = ''
          @state[i].push(val)
        end
      end

      @initialized = true
    end
  end

  def recreate_state
    # need to initialize first
    create_state_data

    # walk through game by move and reconstitute the state of the game.
    self.moves.each do |row|
      self.place_token row.player, row.column, false
    end
  end
end