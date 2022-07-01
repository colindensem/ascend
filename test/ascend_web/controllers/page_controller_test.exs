defmodule AscendWeb.PageControllerTest do
  use AscendWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Listing Hills"
  end
end
