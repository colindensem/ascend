defmodule Ascend.Hills.Hill do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @optional_fields [
    :id,
    :classification,
    :area,
    :grid_ref,
    :area,
    :inserted_at,
    :updated_at,
    :munro,
    :wainwright
  ]

  schema "hills" do
    field :area, :string
    field :classification, :string
    field :dobih_id, :integer
    field :feet, :float
    field :grid_ref, :string
    field :metres, :float
    field :munro, :boolean, default: false
    field :name, :string
    field :region, :string
    field :wainwright, :boolean, default: false
    field :wainwright_outlying_fell, :boolean, default: false

    timestamps()
  end

  def all_fields do
    __MODULE__.__schema__(:fields)
  end

  @doc false
  def changeset(hill, attrs) do
    hill
    |> cast(attrs, all_fields())
    |> validate_required(all_fields() -- @optional_fields)
    |> unique_constraint(:dobih_id)
  end
end
