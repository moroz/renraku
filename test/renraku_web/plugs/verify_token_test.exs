defmodule RenrakuWeb.Plugs.VerifyTokenTest do
  use RenrakuWeb.ConnCase

  alias RenrakuWeb.Plugs.VerifyToken

  test "terminates the request with 401 when no authorization header is attached", %{conn: conn} do
    conn = VerifyToken.call(conn)
    assert conn.halted
    assert text_response(conn, 401) =~ ~r/unauthorized/i
  end

  @valid_jwt String.trim(File.read!("priv/test_jwt"))

  test "lets request through when a valid JWT is attached in Authorization header", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", @valid_jwt)
      |> VerifyToken.call()

    refute conn.halted
    refute conn.status == 401
  end

  test "lets request through when a valid JWT is attached as Bearer token", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer #{@valid_jwt}")
      |> VerifyToken.call()

    refute conn.halted
    refute conn.status == 401
  end
end
