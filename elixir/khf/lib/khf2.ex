defmodule Khf2 do
  @moduledoc """
  Documentation for `Khf1`.
  @author "Pálvölgyi Domonkos <palvolgyid@edu.bme.hu>"
  @date "2023-09-18"

  ## Examples
    iex> Khf2._pad_int(5)
    " 5 "

    iex> Khf2._pad_int(-5)
    "-5 "

    iex> Khf2._make_cols([0,1,2])
    "    0  1  2 "


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

  @type field_data :: :tent | :ground | :tree
  @type row_sum :: integer
  @type row_data :: {row_sum, [field_data]}
  @type col_sum :: integer

  @type tent :: {field, dir}

  @spec _pad_int(num :: integer) :: String.t()
  def _pad_int(num) do
    if(num >= 0) do
      " "
    else
      ""
    end <>
      Integer.to_string(num) <>
      " "
  end

  @spec _tent_list(dirs :: [dir], trees :: trees) :: [tent]
  @doc """
    iex> Khf2._tent_list([:w, :w], [{1,2}, {2,2}])
    [{{1,1}, :w}, {{2,1}, :w}]
  """
  def _tent_list(dirs, trees) do
    Enum.zip([trees, dirs])
    |> Enum.map(fn {tree, dir} ->
      {row, col} = tree

      case dir do
        :n ->
          {{row - 1, col}, dir}

        :e ->
          {{row, col + 1}, dir}

        :s ->
          {{row + 1, col}, dir}

        :w ->
          {{row, col - 1}, dir}
      end
    end)
  end

  @spec _pad_dir(dir :: dir()) :: String.t()
  def _pad_dir(dir) do
    case dir do
      :n -> " N "
      :e -> " E "
      :s -> " S "
      :w -> " W "
    end
  end

  @spec _make_cols(col_sums :: [col_sum()]) :: String.t()
  def _make_cols(col_sums) do
    "   " <> (col_sums |> Enum.map(&_pad_int/1) |> Enum.join())
  end

  @spec _make_rows(
          row_sums :: [row_sum()],
          tents :: [tent],
          trees :: trees,
          col_count :: integer(),
          row_idx :: integer()
        ) :: [String.t()]

  def _make_rows([], _, _, _, _) do
    []
  end

  def _make_rows(
        row_sums,
        tents,
        trees,
        col_count,
        row_idx
      ) do
    [row_sum | rest_row_sums] = row_sums

    # String of field values (tents, trees, ground) tents and trees are in the respective lists and everything else is ground (-)
    field_values =
      Enum.map(1..col_count, fn col_idx ->
        cond do
          Enum.any?(tents, fn {{t_row, t_col}, _} ->
            t_row == row_idx and t_col == col_idx
          end) ->
            {_, dir} =
              tents
              |> Enum.find(fn {{row, col}, _} -> row == row_idx and col == col_idx end)

            _pad_dir(dir)

          Enum.member?(trees, {row_idx, col_idx}) ->
            " * "

          true ->
            " - "
        end
      end)

    [
      _pad_int(row_sum) <> (field_values |> Enum.join())
      | _make_rows(rest_row_sums, tents, trees, col_count, row_idx + 1)
    ]
  end

  # A pd = {rs, cs, ts} feladványleíró és a ds sátorirány-lista alapján
  # a feladvány szöveges ábrázolását írja ki a file fájlba, ahol
  #   rs a sátrak soronkénti számának a listája,
  #   cs a sátrak oszloponkénti számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának lexikálisan rendezett listája
  @spec to_external(pd :: puzzle_desc, ds :: tent_dirs, file :: String.t()) :: :ok
  def to_external(pd, ds, file) do
    {row_sums, col_sums, trees} = pd
    tents = _tent_list(ds, trees)

    ((_make_cols(col_sums) <>
        "\n" <>
        (_make_rows(row_sums, tents, trees, Enum.count(col_sums), 1)
         |> Enum.join("\n"))) <> "\n")
    |> (&File.write(file, &1)).()

    :ok
  end
end
