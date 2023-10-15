defmodule Khf3Test do
  use ExUnit.Case
  doctest Khf3

  test "Empty Camp with Negative Values" do
    assert Khf3.check_sol(
             {[-1, 0, 0, -3, 0], [0, 0, -2, 0, 0], []},
             []
           ) ===
             {%{err_rows: []}, %{err_cols: []}, %{err_touch: []}}
  end

  test "Row and Column Errors" do
    assert Khf3.check_sol({[1, 0, 0, 3, 0], [0, 0, 2, 0, 0], []}, []) ===
             {%{err_rows: [1, 4]}, %{err_cols: [3]}, %{err_touch: []}}
  end

  test "Good Solution" do
    assert Khf3.check_sol(
             {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
             [:e, :s, :n, :n, :n]
           ) ===
             {%{err_rows: []}, %{err_cols: []}, %{err_touch: []}}
  end

  test "Full Test 1" do
    assert Khf3.check_sol(
             {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
             [:e, :e, :n, :n, :n]
           ) ===
             {%{err_rows: [3, 4]}, %{err_cols: [3, 4]}, %{err_touch: [{2, 5}, {3, 4}, {4, 5}]}}
  end

  test "Full Test 2" do
    assert Khf3.check_sol(
             {[1, 0, 2, 2, 0], [1, 0, 0, 2, 1], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
             [
               :e,
               :e,
               :n,
               :n,
               :n
             ]
           ) ===
             {%{err_rows: [2, 3]}, %{err_cols: [3, 4, 5]}, %{err_touch: [{2, 5}, {3, 4}, {4, 5}]}}
  end

  test "Full Test 3 (Negative tents count)" do
    assert Khf3.check_sol(
             {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
             [:e, :s, :n, :n, :w]
           ) ===
             {%{err_rows: [4, 5]}, %{err_cols: [4, 5]}, %{err_touch: [{4, 3}, {5, 4}]}}
  end

  test "Real Test 1" do
    Khf3.check_sol(
      {[1, 2, 2, 0, 2, 1, 1], [1, 2, 1, 2, 0, 1, 1, 1],
       [{1, 4}, {1, 8}, {2, 2}, {3, 3}, {3, 6}, {5, 2}, {5, 5}, {5, 7}, {7, 3}]},
      [:w, :s, :s, :e, :n, :w, :w, :s, :w]
    )
  end
end
