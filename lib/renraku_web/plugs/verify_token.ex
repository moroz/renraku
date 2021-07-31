defmodule RenrakuWeb.Plugs.VerifyToken do
  @behaviour Plug

  import Plug.Conn
  alias Renraku.Token

  @impl true
  def init(options), do: options

  @impl true
  def call(conn, _options) do
    case fetch_and_verify_token(conn) do
      nil ->
        conn
        |> put_status(401)
        |> halt()

      payload ->
        assign(conn, :auth_payload, payload)
    end
  end

  @spec fetch_and_verify_token(conn :: Plug.Conn.t()) :: nil | map
  defp fetch_and_verify_token(%Plug.Conn{} = conn) do
    case fetch_token(conn) do
      nil ->
        nil

      token ->
        case Token.verify_and_validate(token) do
          {:ok, payload} ->
            payload

          _ ->
            nil
        end
    end
  end

  defp fetch_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        token

      [token] ->
        token

      _ ->
        nil
    end
  end
end
