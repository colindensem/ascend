defmodule AscendWeb.HillLiveTest do
  use AscendWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ascend.HillsFixtures

  @create_attrs %{
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
  }
  @update_attrs %{
    area: "some updated area",
    classification: "some updated classification",
    dobih_id: 43,
    feet: 456.7,
    grid_ref: "some updated grid_ref",
    metres: 456.7,
    munro: false,
    name: "some updated name",
    region: "some updated region",
    wainwright: false,
    wainwright_outlying_fell: false
  }
  @invalid_attrs %{
    area: nil,
    classification: nil,
    dobih_id: nil,
    feet: nil,
    grid_ref: nil,
    metres: nil,
    munro: false,
    name: nil,
    region: nil,
    wainwright: false,
    wainwright_outlying_fell: false
  }

  defp create_hill(_) do
    hill = hill_fixture()
    %{hill: hill}
  end

  describe "Index" do
    setup [:create_hill]

    test "lists all hills", %{conn: conn, hill: hill} do
      {:ok, _index_live, html} = live(conn, Routes.hill_index_path(conn, :index))

      assert html =~ "Listing Hills"
      assert html =~ hill.area
    end
  end

  describe "Show" do
    setup [:create_hill]

    test "displays hill", %{conn: conn, hill: hill} do
      {:ok, _show_live, html} = live(conn, Routes.hill_show_path(conn, :show, hill))

      assert html =~ "Show Hill"
      assert html =~ hill.area
    end
  end
end
