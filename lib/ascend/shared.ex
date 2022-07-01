defmodule Ascend.Shared do
  defmacro __using__(_opts) do
    quote do
      alias Ascend.Hills
      alias Ascend.Hills.Hill
    end
  end
end
