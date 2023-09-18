defmodule Khf1 do
  @moduledoc """
  Documentation for `Khf1`.
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

  @type field_data :: :tent | :ground | :tree
  @type row_sum :: integer
  @type row_data :: {row_sum, [field_data]}

  @spec _parse_field_data(fd :: String.t()) :: field_data
  def _parse_field_data(fd) do
    case fd |> String.trim() do
      "-" ->
        :ground

      "*" ->
        :tree
    end
  end

  def _cut_header([]) do
    []
  end

  @spec _cut_header(row_raws :: [String.t()]) :: [row_data]
  def _cut_header(row_raws) do
    [cur_row_raw | rest] = row_raws

    row_elems =
      cur_row_raw |> String.trim() |> String.split()

    [row_sum_raw | row_rest_raw] = row_elems
    {row_sum, _} = row_sum_raw |> Integer.parse()
    row_fds = row_rest_raw |> Enum.map(&_parse_field_data/1)

    [{row_sum, row_fds} | _cut_header(rest)]
  end

  def _find_trees([], _row_idx) do
    []
  end

  @spec _find_trees(row_datas :: [row_data], row_idx :: integer) :: [field]
  def _find_trees(row_datas, row_idx) do
    [cur_row | rest] = row_datas
    {_, fds} = cur_row

    trees =
      fds
      |> Enum.with_index()
      |> Enum.filter(fn {fd, _idx} -> fd == :tree end)
      |> Enum.map(fn {_fd, col_idx} -> {row_idx, col_idx + 1} end)

    [trees | _find_trees(rest, row_idx + 1)] |> List.flatten()
  end

  @spec to_internal(file :: String.t()) :: pd :: puzzle_desc()
  def to_internal(file) do
    {:ok, body} = File.read(file)
    lines = body |> String.split("\n")
    [col_clounts_raw | rest] = lines

    col_counts =
      col_clounts_raw
      |> String.split()
      |> Enum.map(fn x ->
        {n, _} = x |> Integer.parse()
        n
      end)

    row_datas = rest |> _cut_header()
    row_counts = row_datas |> Enum.map(fn {n, _} -> n end)

    trees = _find_trees(row_datas, 1)

    {row_counts, col_counts, trees}
  end
end
