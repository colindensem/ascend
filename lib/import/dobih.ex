defmodule Import.Dobih do
  @moduledoc """
    Utility module to ingest `DoBIH.csv`
  """
  use Ascend.Shared
  alias Ascend.Repo

  alias NimbleCSV.RFC4180, as: CSV

  def import(file) do
    column_names = get_column_names(file)

    file
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: true)
    |> Enum.map(fn row ->
      row
      |> Enum.with_index()
      |> Map.new(fn {val, num} -> {column_names[num], val} end)
      |> create_or_skip()
    end)
  end

  defp get_column_names(file) do
    file
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)
  end

  defp create_or_skip(row) do
    case Repo.get_by(Hill, dobih_id: row["Number"]) do
      nil ->
        classifications = classification_list_to_atom_list(row["Classification"])

        Hills.create_hill(%{
          area: row["Area"],
          classification: row["Classification"],
          dobih_id: row["Number"],
          feet: row["Feet"],
          grid_ref: row["Grid ref"],
          metres: feet_or_metres(row["Metres"], row["Feet"]),
          name: row["Name"],
          region: row["Region"],
          munro: Enum.member?(classifications, :munro),
          wainwright: Enum.member?(classifications, :wainwright)
        })

      hill ->
        classifications = classification_list_to_atom_list(row["Classification"])

        Hills.update_hill(hill, %{
          area: row["Area"],
          classification: row["Classification"],
          dobih_id: row["Number"],
          feet: row["Feet"],
          grid_ref: row["Grid ref"],
          metres: feet_or_metres(row["Metres"], row["Feet"]),
          name: row["Name"],
          region: row["Region"],
          munro: Enum.member?(classifications, :munro),
          wainwright: Enum.member?(classifications, :wainwright)
        })
    end
  end

  defp feet_or_metres(nil = _metres, nil = _feet), do: 0
  defp feet_or_metres(nil = _metres, feet), do: String.to_integer(feet) * 0.3
  defp feet_or_metres(metres, _feet), do: metres

  defp classification_list_to_atom_list(classification) do
    classification
    |> String.split(",")
    |> Enum.map(fn key -> Hills.mappings()[key] end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn key ->
      key
      |> String.downcase()
      |> String.replace(" ", "_")
      |> String.to_atom()
    end)
  end
end
