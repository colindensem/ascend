defmodule Ascend.Factory do
  use ExMachina.Ecto, repo: Ascend.Repo
  alias Ascend.Hills.Hill

  def hill_factory do
    %Hill{
      area: "some area",
      classification: "some classification",
      dobih_id: sequence(:dobih_id, & &1),
      feet: 1640.42,
      grid_ref: "GR 123 456",
      metres: 500,
      munro: true,
      name: "some name",
      region: "some region",
      wainwright: false,
      wainwright_outlying_fell: false
    }
  end
end
