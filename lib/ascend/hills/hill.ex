defmodule Ascend.Hills.Hill do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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

  @doc false
  def changeset(hill, attrs) do
    hill
    |> cast(attrs, [:name, :dobih_id, :metres, :feet, :grid_ref, :classification, :region, :area, :munro, :wainwright, :wainwright_outlying_fell])
    |> validate_required([:name, :dobih_id, :metres, :feet, :grid_ref, :classification, :region, :area, :munro, :wainwright, :wainwright_outlying_fell])
  end
end
