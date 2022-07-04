defmodule AscendWeb.Forms.FilterForm do
  import Ecto.Changeset

  @fields %{
    name: :string
  }

  @default_values %{
    name: nil
  }

  def default_values(overrides \\ %{}) do
    Map.merge(@default_values, overrides)
  end

  def parse(params) do
    {@default_values, @fields}
    |> cast(params, Map.keys(@fields))
    |> apply_action(:insert)
  end

  def change_values(values \\ @default_values) do
    {values, @fields}
    |> cast(%{}, Map.keys(@fields))
  end
end
