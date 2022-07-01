defmodule AscendWeb.HillLiveTest do
  use AscendWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ascend.Factory

  defp create_hill(_) do
    hill = insert(:hill)
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
