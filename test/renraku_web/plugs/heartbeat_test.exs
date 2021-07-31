defmodule RenrakuWeb.Plugs.HeartbeatTest do
  use RenrakuWeb.ConnCase

  test "responds with an empty 204 response", %{conn: conn} do
    conn = RenrakuWeb.Plugs.Heartbeat.call(conn)
    assert response(conn, 204) == ""
  end
end
