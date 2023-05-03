defmodule MaxoOpTest do
  use ExUnit.Case
  use MnemeDefaults

  test "greeting" do
    auto_assert(MaxoOp.greeting())
  end
end
