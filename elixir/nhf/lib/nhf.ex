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

  # tss a pd feladványleíróval megadott feladvány összes megoldásának listája, tetszőleges sorrendben
  @spec satrak(pd :: puzzle_desc) :: tss :: [tent_dirs]

  def satrak(pd) do
  end
end
