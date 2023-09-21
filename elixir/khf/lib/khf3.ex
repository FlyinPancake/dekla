defmodule Khf3 do
  @moduledoc """
  Khf3
  @author "Pálvölgyi Domonkos <palvolgyid@edu.bme.hu>"
  @date "2023-09-18"
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

  # a fák száma a kempingben
  @type cnt_tree :: integer
  # az elemek száma a sátorpozíciók irányának listájában
  @type cnt_tent :: integer
  # a sátrak száma rossz a felsorolt sorokban
  @type err_rows :: %{err_rows: [integer]}
  # a sátrak száma rossz a felsorolt oszlopokban
  @type err_cols :: %{err_cols: [integer]}
  # a felsorolt koordinátájú sátrak másikat érintenek
  @type err_touch :: %{err_touch: [field]}
  # hibaleíró hármas
  @type errs_desc :: {err_rows, err_cols, err_touch}

  @type field_type :: :tree | :tent | :empty

  @type row_cnt :: integer
  @type col_cnt :: integer
  @type camp_size :: {row_cnt, col_cnt}
  @type row_data :: [field_type]
  @type col_data :: [field_type]
  @type camp_grid :: [row_data]

  @spec _count_row(row :: row_data) :: integer()
  def _count_row(row) do
    row
    |> Enum.filter(fn t -> t == :tent end)
    |> length()
  end

  @spec _tent_location(tree :: field, dir) :: field
  def _tent_location(tree, dir) do
    {row, col} = tree

    case dir do
      :n -> {row - 1, col}
      :e -> {row, col + 1}
      :s -> {row + 1, col}
      :w -> {row, col - 1}
    end
  end

  @spec _create_camp_grid(
          camp_size :: camp_size,
          trees :: trees,
          tent_dirs :: tent_dirs
        ) :: camp_grid
  @doc """
  iex>Khf3._create_camp_grid({2,2},[{1,1}], [:e])
  [[:tree,:tent], [:empty,:empty]]
  """
  def _create_camp_grid(camp_size, trees, tent_dirs) do
    {row_cnt, col_cnt} = camp_size

    tents =
      Enum.zip([trees, tent_dirs])
      |> Enum.map(fn {tree, dir} -> _tent_location(tree, dir) end)

    for cur_row <- 1..row_cnt do
      for cur_col <- 1..col_cnt do
        cond do
          Enum.any?(trees, fn {row, col} ->
            row == cur_row and col == cur_col
          end) ->
            :tree

          Enum.any?(tents, fn {row, col} ->
            row == cur_row and col == cur_col
          end) ->
            :tent

          true ->
            :empty
        end
      end
    end
  end

  @spec _get_cols(camp_grid) :: [col_data]
  @doc """
  iex>Khf3._get_cols([[:tree, :tent], [:empty, :empty]])
  [[:tree, :empty], [:tent, :empty]]
  """
  def _get_cols(camp_grid) do
    cols = camp_grid |> Enum.at(0) |> length()
    # rows = camp_grid |> length()

    for cur_col <- 1..cols do
      camp_grid |> Enum.map(fn row -> row |> Enum.at(cur_col - 1) end)
    end
  end

  @spec _test_rows(rows :: camp_grid, expected_counts :: tents_count_rows) :: [integer]
  def _test_rows(rows, expected_counts) do
    rows_cnt = rows |> Enum.at(0) |> length()

    for cur_row <- 1..rows_cnt do
      exp_tent_count = expected_counts |> Enum.at(cur_row - 1)
      act_tent_count = _count_row(rows |> Enum.at(cur_row - 1))

      if exp_tent_count == act_tent_count or exp_tent_count < 0 do
        nil
      else
        cur_row
      end
    end
    |> Enum.filter(fn e -> e != nil end)
  end

  @spec _test_touch(grid :: camp_grid) :: [field]
  @doc """
  iex> Khf3._test_touch([[:empty, :tree, :tent, :empty, :empty],[:empty, :empty, :empty, :empty, :tent],[:empty, :empty, :tree, :tent, :tree],[:tent, :empty, :empty, :empty, :tent],[:tree, :empty, :empty, :empty, :tree]])
  [{2, 5}, {3, 4}, {4, 5}]
  """
  def _test_touch(grid) do
    height = grid |> length()
    width = grid |> Enum.at(0) |> length()

    tents =
      for row <- 0..(height - 1) do
        for col <- 0..(width - 1) do
          if grid |> Enum.at(row) |> Enum.at(col) == :tent do
            {row, col}
          end
        end
      end
      |> Enum.concat()
      |> Enum.filter(fn e -> e != nil end)

    tents
    |> Enum.filter(fn tent ->
      rest = Enum.filter(tents, fn e -> e != tent end)
      {row, col} = tent

      Enum.any?(rest, fn {other_row, other_col} ->
        abs(other_row - row) <= 1 and abs(other_col - col) <= 1
      end)
    end)
    |> Enum.map(fn {row, col} -> {row + 1, col + 1} end)
  end

  # Az {rs, cs, ts} = pd feladványleíró és a ds sátorirány-lista
  # alapján elvégzett ellenőrzés eredménye a ed hibaleíró, ahol
  #   rs a sátrak soronként elvárt számának a listája,
  #   cs a sátrak oszloponként elvárt számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának a listája
  # Az {e_rows, e_cols, e_touch} = ed hármas elemei olyan
  # kulcs-érték párok, melyekben a kulcs a hiba jellegére utal, az
  # érték pedig a hibahelyeket felsoroló lista (üres, ha nincs hiba)
  @spec check_sol(pd :: puzzle_desc, ds :: tent_dirs) :: ed :: errs_desc
  @doc """
  iex> Khf3.check_sol {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}, [:e,:s,:n,:n,:n]
  {%{err_rows: []}, %{err_cols: []}, %{err_touch: []}}

  iex> Khf3.check_sol {[1, 0, 0, 3, 0], [0, 0, 2, 0, 0], []}, []
  {%{err_rows: [1,4]}, %{err_cols: [3]}, %{err_touch: []}}
  """
  def check_sol(pd, ds) do
    {tents_count_rows, tents_count_cols, trees} = pd
    rows_cnt = tents_count_rows |> length()
    cols_cnt = tents_count_cols |> length()
    grid = _create_camp_grid({rows_cnt, cols_cnt}, trees, ds)
    cols = _get_cols(grid)

    err_rows = _test_rows(grid, tents_count_rows)
    err_cols = _test_rows(cols, tents_count_cols)
    err_touch = _test_touch(grid)

    {
      %{err_rows: err_rows},
      %{err_cols: err_cols},
      %{err_touch: err_touch}
    }
  end
end
