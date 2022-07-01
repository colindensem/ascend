defmodule AscendWeb.Forms.SortingForm do
  import Ecto.Changeset
  alias Ascend.EctoHelper

  @sortable_fields [:dobih_id, :name, :metres, :feet]

  @fields %{
    sort_by: EctoHelper.enum(@sortable_fields),
    sort_dir: EctoHelper.enum([:asc, :desc])
  }

  @default_values %{
    sort_by: :metres,
    sort_dir: :desc
  }

  def parse(params) do
    {@default_values, @fields}
    |> cast(params, Map.keys(@fields))
    |> apply_action(:insert)
  end

  def default_values(), do: @default_values
end
