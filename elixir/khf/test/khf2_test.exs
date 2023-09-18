defmodule Khf2Test do
  use ExUnit.Case
  doctest Khf2

  test "Empty Lot" do
    puzzle0 = {[-1, 0, 0, -3, 0], [0, 0, -2, 0, 0], []}
    temp_dir = System.tmp_dir!()
    result_path = Path.join(temp_dir, "puzzle0.txt")
    Khf2.to_external(puzzle0, [], result_path)
    {:ok, expected} = File.read("test/assets/khf2_0.txt")
    {:ok, actual} = File.read(result_path)
    assert expected |> String.trim() == actual |> String.trim()
  end

  test "Puzzle 1" do
    puzzle = {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
    dirs = [:e, :s, :n, :n, :n]

    temp_dir = System.tmp_dir!()

    result_path = Path.join(temp_dir, "puzzle1.txt")
    Khf2.to_external(puzzle, dirs, result_path)
    {:ok, expected} = File.read("test/assets/khf2_1.txt")
    {:ok, actual} = File.read(result_path)
    assert expected |> String.trim() == actual |> String.trim()
  end

  test "Puzzle 2" do
    puzzle = {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}

    dirs = [:e, :s, :n, :n, :w]
    temp_dir = System.tmp_dir!()

    result_path = Path.join(temp_dir, "puzzle2.txt")
    Khf2.to_external(puzzle, dirs, result_path)
    {:ok, expected} = File.read("test/assets/khf2_2.txt")
    {:ok, actual} = File.read(result_path)
    assert expected |> String.trim() == actual |> String.trim()
  end

  test "Puzzle 3" do
    puzzle = {[2], [0, 1, -1, 0, -1], [{1, 1}, {1, 4}]}
    dirs = [:e, :e]
    temp_dir = System.tmp_dir!()
    result_path = Path.join(temp_dir, "puzzle3.txt")
    Khf2.to_external(puzzle, dirs, result_path)
    {:ok, expected} = File.read("test/assets/khf2_3.txt")
    {:ok, actual} = File.read(result_path)
    assert expected |> String.trim() == actual |> String.trim()
  end

  test "Puzzle 4" do
    puzzle = {[0, -1, 0, 1, 1, 0], [3], [{1, 1}, {3, 1}, {6, 1}]}
    dirs = [:s, :s, :n]
    temp_dir = System.tmp_dir!()
    result_path = Path.join(temp_dir, "puzzle4.txt")
    Khf2.to_external(puzzle, dirs, result_path)
    {:ok, expected} = File.read("test/assets/khf2_4.txt")
    {:ok, actual} = File.read(result_path)
    assert expected |> String.trim() == actual |> String.trim()
  end
end
