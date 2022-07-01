defmodule Ascend.HillsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ascend.Hills` context.
  """

  @doc """
  Generate a hill.
  """
  def hill_fixture(attrs \\ %{}) do
    {:ok, hill} =
      attrs
      |> Enum.into(%{
        area: "some area",
        classification: "some classification",
        dobih_id: 42,
        feet: 120.5,
        grid_ref: "some grid_ref",
        metres: 120.5,
        munro: true,
        name: "some name",
        region: "some region",
        wainwright: true,
        wainwright_outlying_fell: true
      })
      |> Ascend.Hills.create_hill()

    hill
  end
end
