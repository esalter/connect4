require 'json'

class GameState
  def initialize(rows=6, columns=7, first_player=1)
    @state = []
    @rows = rows
    @columns = columns
    @current_player = first_player
    rows.times do |i|
      @state.push([])
      columns.times do |j|
        val = ''
        @state[i].push(val)
      end
    end
  end

  def place_token(player, column)
    if player == current_player
      # find the first free slot.
      row = 0

      begin
        if @state[row][column] == ''
          @state[row][column] = player
          set_next_player
          break
        end
        row += 1
      end until row >= @rows
    end

    self
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
    @rows.times do |i|
      column.push(@state[i][index])
    end

    column
  end

  def to_json(options = {})
    # we keep the state in a "reversed" manner (bottom-up) to keep things a bit easier to calculate
    # but we don't want to expose that to the consuming code which expects left-right top-down
    # interpretation.
    JSON.pretty_generate(@state.reverse, options)
  end
end