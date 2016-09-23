class Scorer
  def initialize(state, rows, columns)
    @state = state
    @rows = rows
    @columns = columns
  end

  # just a special case to find who won
  def find_win
    result = { count: check_runs(1, 4), player: 1 }
    if result[:count] == 0
      result = { count: check_runs(2, 4), player: 2 }
      if result[:count] == 0
        result = { count: 0, player: nil }
      end
    end

    result
  end

  def check_runs(player, run)
    count_runs = 0
    @rows.times do |i|
      @columns.times do |j|

        count_runs += check_horizontal_runs(player, i, j, run)[:count] +
                check_vertical_runs(player, i, j, run)[:count] +
                check_diag_runs(player, i, j, run)[:count]
      end
    end

    count_runs
  end

  def check_horizontal_runs(player, start_row, start_col, threshold)
    consecutive = 0
    (start_col..start_col+3).each do |i|
      if i < @columns
        if @state[start_row][i] == player
          consecutive+=1
        elsif @state[start_row][i] == ''
          # this is ok, keep going.
        else
          # not ok, its the other player; bomb out.
          break;
        end
      end
    end
    { run: consecutive, threshold: threshold, count: consecutive >= threshold ? 1 : 0 }
  end

  def check_vertical_runs(player, start_row, start_col, threshold)
    consecutive = 0
    (start_row..start_row+3).each do |i|
      if i < @rows
        if @state[i][start_col] == player
          consecutive+=1
        elsif @state[i][start_col] == ''
          # this is ok, keep going.
        else
          # not ok, its the other player; bomb out.
          break;
        end
      end
    end

    { run: consecutive, threshold: threshold, count: consecutive >= threshold ? 1 : 0}
  end

  def check_diag_runs(player, start_row, start_col, threshold)

    # check lower-left - upper-right diag
    total_runs = 0
    consecutive = 0
    (0..3).each do |i|
      if start_row+i < @rows && start_col + i < @columns
        if @state[start_row+i][start_col+i] == player
          consecutive+=1
        elsif @state[start_row+i][start_col+i] == ''
          # this is ok, keep going.
        else
          # not ok, its the other player; bomb out.
          break;
        end
      end
    end

    # check upper-left - lower-right diag
    total_runs += consecutive >= threshold ? 1 : 0
    consecutive = 0
    (0..3).each do |i|
      row = start_row+3-i
      if row < @rows && start_col+i < @columns
        if @state[row][start_col+i] == player
          consecutive+=1
        elsif @state[row][start_col+i] == ''
          # this is ok, keep going.
        else
          # not ok, its the other player; bomb out.
          break;
        end
      end
    end

    total_runs += consecutive >= threshold ? 1 : 0
    { run: consecutive, threshold: threshold, count: total_runs }
  end
end