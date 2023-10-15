defmodule Nhf1 do
  @moduledoc """
  Kemping
  @author "Egyetemi Hallgató <egy.hallg@dp.vik.bme.hu>"
  @date   "2022-10-15"
  ...
  """

  # sor száma (1-től n-ig)
  @type row :: integer
  # oszlop száma (1-től m-ig)
  @type col :: integer
  # egy parcella koordinátái
  @type field :: {row, col}

  # a sátrak száma soronként
  @type tents_count_rows :: [integer]
  # a sátrak száma oszloponként
  @type tents_count_cols :: [integer]

  # a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
  @type trees :: [field]
  # a feladványleíró hármas
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

  # a sátorpozíciók iránya: north, east, south, west
  @type dir :: :n | :e | :s | :w
  # a sátorpozíciók irányának listája a fákhoz képest
  @type tent_dirs :: [dir]

  @type field_kind :: :tree | :tent | :empty
  @type row_fields :: [field_kind]
  @type grid :: [row_fields]

  @spec parse_puzzle_desc(pd :: puzzle_desc()) :: grid()
  defp parse_puzzle_desc(pd) do
    {tents_count_rows, tents_count_cols, trees} = pd

    for row <- 1..length(tents_count_rows) do
      for col <- 1..length(tents_count_cols) do
        if Enum.any?(trees, fn {t_row, t_col} -> t_row == row and t_col == col end) do
          :tree
        else
          :empty
        end
      end
    end
  end

  @spec get_from_grid_at(grid :: grid, row :: row, col :: col) :: field_kind
  defp get_from_grid_at(grid, row, col) do
    Enum.at(Enum.at(grid, row - 1), col - 1)
  end

  @spec populate_grid(grid :: grid, tent_dirs :: tent_dirs) :: grid
  defp populate_grid(grid, tent_dirs) do
    for row_idx <- 1..(grid |> length()) do
      for col_idx <- 1..(grid |> Enum.at(row_idx - 1) |> length()) do
        if Enum.any?(tent_dirs, fn {r, c} -> r == row_idx and c == col_idx end) do
          :tent
        else
          get_from_grid_at(grid, row_idx, col_idx)
        end
      end
    end
  end

  @spec get_adjacent_cell(row :: row, col :: col, dir :: dir) :: field
  defp get_adjacent_cell(row, col, dir) do
    case dir do
      :n -> {row - 1, col}
      :e -> {row, col + 1}
      :s -> {row + 1, col}
      :w -> {row, col - 1}
    end
  end

  @spec is_valid_tent_position(
          grid :: grid,
          row :: row,
          col :: col,
          tents_count_rows :: tents_count_rows,
          tents_count_cols :: tents_count_cols
        ) :: boolean
  defp is_valid_tent_position(grid, row, col, tents_count_rows, tents_count_cols) do
    # Check if the cell is empty and
    # Check if the tent does not touch another tent diagonally and

    Enum.at(Enum.at(grid, row - 1), col - 1) === :empty and
      not is_diagonal_tent(grid, row, col) and
      (tents_count_rows |> Enum.at(row - 1) >=
         Enum.count(Enum.at(grid, row - 1), fn cell -> cell == :tent end) or
         tents_count_rows |> Enum.at(row - 1) < 0) and
      (tents_count_cols |> Enum.at(col - 1) >=
         Enum.count(Enum.map(grid, fn row -> Enum.at(row, col - 1) end), fn cell ->
           cell == :tent
         end) or
         tents_count_cols |> Enum.at(col - 1) < 0)
  end

  @spec get_valid_dirs(grid :: grid, row :: row, col :: col) ::
          [dir]
  defp get_valid_dirs(grid, row, col) do
    [:n, :e, :s, :w]
    |> Enum.filter(fn dir ->
      {adj_row, adj_col} = get_adjacent_cell(row, col, dir)

      adj_row > 0 and
        adj_col > 0 and
        adj_row <= length(grid) and
        adj_col <= length(Enum.at(grid, adj_row - 1))
    end)
  end

  # Checks if the tent is touching another tent diagonally (i.e. in the north-west, north-east, south-west or south-east direction)
  @spec is_diagonal_tent(grid :: grid, row :: row, col :: col) ::
          boolean
  defp is_diagonal_tent(grid, row, col) do
    {row, col}
    valid_dirs = get_valid_dirs(grid, row, col)

    for dir <- valid_dirs do
      {r, c} = get_adjacent_cell(row, col, dir)
      grid |> Enum.at(r - 1) |> Enum.at(c - 1) === :tent
    end
    |> Enum.any?() or
      if Enum.member?(valid_dirs, :n) and
           Enum.member?(valid_dirs, :e) do
        grid |> Enum.at(row - 2) |> Enum.at(col) === :tent
      else
        false
      end or
      if Enum.member?(valid_dirs, :n) and Enum.member?(valid_dirs, :w) do
        grid |> Enum.at(row - 2) |> Enum.at(col - 2) === :tent
      else
        false
      end or
      if Enum.member?(valid_dirs, :s) and Enum.member?(valid_dirs, :e) do
        grid |> Enum.at(row) |> Enum.at(col) === :tent
      else
        false
      end or
      if Enum.member?(valid_dirs, :s) and Enum.member?(valid_dirs, :w) do
        grid |> Enum.at(row) |> Enum.at(col - 2) === :tent
      else
        false
      end
  end

  @spec satisfies_row_constraints(grid :: grid, tents_count_rows :: tents_count_rows) :: boolean
  defp satisfies_row_constraints(grid, tents_count_rows) do
    for row <- 1..length(tents_count_rows) do
      tents_in_row = Enum.count(Enum.at(grid, row - 1), fn cell -> cell == :tent end)
      expected_tents_in_row = Enum.at(tents_count_rows, row - 1)
      tents_in_row == expected_tents_in_row or expected_tents_in_row < 0
    end
    |> Enum.all?()
  end

  @spec satisfies_col_constraints(grid :: grid, tents_count_cols :: tents_count_cols) :: boolean
  defp satisfies_col_constraints(grid, tents_count_cols) do
    for col <- 1..length(tents_count_cols) do
      tents_in_col =
        Enum.count(Enum.map(grid, fn row -> Enum.at(row, col - 1) end), fn cell ->
          cell == :tent
        end)

      expected_tents_in_col = Enum.at(tents_count_cols, col - 1)

      tents_in_col == expected_tents_in_col or expected_tents_in_col < 0
    end
    |> Enum.all?()
  end

  # tss a pd feladványleíróval megadott feladvány összes megoldásának listája, tetszőleges sorrendben
  @spec satrak(pd :: puzzle_desc) :: tss :: [tent_dirs]
  def satrak(pd) do
    {tents_count_rows, tents_count_cols, trees} = pd
    grid = parse_puzzle_desc(pd)

    # Initialize the list of tent positions with an empty list
    tent_positions = []

    # Call the recursive helper function to find all possible tent configurations
    find_tent_configs(grid, trees, tent_positions, tents_count_rows, tents_count_cols)
    |> Enum.reverse()
  end

  @spec find_tent_configs(
          grid :: grid,
          trees :: trees,
          tent_positions :: tent_dirs,
          tents_count_rows :: tents_count_rows,
          tents_count_cols :: tents_count_cols
        ) :: [tent_dirs]
  defp find_tent_configs(grid, trees, tent_positions, tents_count_rows, tents_count_cols) do
    populated_grid =
      populate_grid(
        grid,
        [trees, tent_positions]
        |> Enum.zip()
        |> Enum.map(fn {{r, c}, dir} -> get_adjacent_cell(r, c, dir) end)
      )

    # If all tents have been placed, then we have found a valid configuration
    if length(tent_positions) === length(trees) do
      # Return the list of tent positions
      if satisfies_row_constraints(populated_grid, tents_count_rows) and
           satisfies_col_constraints(populated_grid, tents_count_cols) do
        [tent_positions]
      else
        []
      end
    else
      # Find the first tree that has not been assigned a tent yet
      {tree_row, tree_col} =
        Enum.at(trees, length(tent_positions))

      # Find all valid tent positions for the current tree
      valid_dirs =
        get_valid_dirs(populated_grid, tree_row, tree_col)
        |> Enum.filter(fn dir ->
          {r, c} = get_adjacent_cell(tree_row, tree_col, dir)
          is_valid_tent_position(populated_grid, r, c, tents_count_rows, tents_count_cols)
        end)

      for dir <- valid_dirs do
        find_tent_configs(
          populated_grid,
          trees,
          tent_positions ++ [dir],
          tents_count_rows,
          tents_count_cols
        )
      end
      |> Enum.flat_map(& &1)

      # For each valid tent position, call the recursive helper function to find all possible tent configurations
    end
  end
end
