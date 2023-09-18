defmodule KhfTest do
  use ExUnit.Case
  doctest Khf1

  test "khf1_1" do
    result = Khf1.to_internal("test/assets/khf1_1.txt")
    assert result == {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
  end

  test "khf1_2" do
    assert Khf1.to_internal("test/assets/khf1_2.txt") ==
             {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
  end
end
