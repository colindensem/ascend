defmodule Ascend.Repo.Migrations.CreateHills do
  use Ecto.Migration

  def change do
    create table(:hills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :area, :string
      add :classification, :string
      add :dobih_id, :integer, null: false
      add :feet, :float, null: false
      add :grid_ref, :string
      add :metres, :float, null: false
      add :name, :string, null: false
      add :region, :string, null: false
      add :munro, :boolean, default: false, null: false
      add :wainwright, :boolean, default: false, null: false
      add :wainwright_outlying_fell, :boolean, default: false, null: false

      timestamps()
    end

    create(unique_index(:hills, :dobih_id))
  end
end
