defmodule RenrakuWeb.Plugs.VerifyToken do
  @behaviour Plug

  @moduledoc """
  Plug middleware to verify JWT tokens passed with the request and deny access if
  no JWT was given.

  The JWT needs to be issued by another application, signed with the valid RS256 key
  and attached to the request in the `Authorization` header. It is customary to prepend
  `Authorization` tokens with the string `"Bearer "` (so-called bearer tokens). This is
  supported but not required, you can pass just the token.

  If a valid token is passed with the request, its payload will be `assign`ed on the
  conn under the key `:auth_payload` and the request goes through. If no valid token
  is passed with the request, the request will be terminated with a 401 response.

  In development, it is possible to disable this check and allow unauthorized request
  to pass through by setting the environment variable `DISABLE_AUTH` to `"true"`.
  This option does not set any test `:auth_payload` assign, but merely prevents the
  middleware from denying access to the application.
  """

  import Plug.Conn
  alias Renraku.Token

  @impl true
  def init(options), do: options

  @impl true
  def call(conn, _options \\ []) do
    case fetch_and_verify_token(conn) do
      nil ->
        if should_deny_access?() do
          deny_access(conn)
        else
          conn
        end

      payload ->
        assign(conn, :auth_payload, payload)
    end
  end

  @is_prod Mix.env() == :prod
  defp should_deny_access? do
    @is_prod or System.get_env("DISABLE_AUTH") != "true"
  end

  defp deny_access(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "Unauthorized")
    |> halt()
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
