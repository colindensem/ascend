defmodule AscendWeb.Forms.PaginationForm do
  import Ecto.Changeset

  @fields %{
    page_size: :integer,
    page: :integer,
    total_count: :integer
  }

  @default_values %{
    page: 1,
    page_size: 20,
    total_count: 0
  }

  def parse(params, values \\ @default_values) do
    {values, @fields}
    |> cast(params, Map.keys(@fields))
    |> validate_number(:page, greater_than: 0)
    |> validate_number(:page_size, greater_than: 0)
    |> validate_number(:page_size, less_than: 101)
    |> validate_number(:total_count, greater_than_or_equal: 0)
    |> apply_action(:insert)
  end

  def default_values(overrides \\ %{}) do
    Map.merge(@default_values, overrides)
  end
end
