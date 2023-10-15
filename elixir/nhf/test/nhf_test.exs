defmodule NhfTest do
  use ExUnit.Case
  doctest Nhf1

  test "Sanity" do
    assert Nhf1.satrak({[0, 2, 0], [1, 0, 1], [{1, 1}, {1, 3}]}) == [[:s, :s]]
  end

  test "Case 1" do
    assert Nhf1.satrak(
             {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
           ) === [[:e, :s, :n, :n, :n]]
  end

  test "Case 2" do
    assert Nhf1.satrak(
             {[-1, -1, -1, 3, 0], [-1, -2, -2, 0, -2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
           ) ===
             [[:w, :s, :n, :n, :n], [:s, :s, :n, :n, :n], [:e, :s, :n, :n, :n]]
  end

  test "Case 3" do
    Nhf1.satrak(
      {[3, 0, 3, 0, 3], [3, 0, 3, 0, 3],
       [{1, 2}, {1, 4}, {2, 1}, {2, 5}, {3, 4}, {4, 1}, {4, 5}, {5, 2}, {5, 4}]}
    ) === [[:e, :e, :n, :s, :w, :n, :s, :w, :w], [:w, :w, :s, :n, :w, :s, :n, :e, :e]]
  end

  test "Case 4" do
    Nhf1.satrak({[-2, -1, -1, -1], [-2, -1, -1, -1], [{1, 2}, {1, 4}, {3, 2}, {4, 3}]}) === [
      [:s, :s, :s, :e],
      [:w, :s, :s, :e],
      [:w, :s, :w, :e],
      [:w, :w, :s, :e],
      [:w, :w, :w, :e],
      [:w, :w, :w, :n]
    ]
  end
end
