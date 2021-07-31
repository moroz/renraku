defmodule RenrakuWeb.Plugs.Heartbeat do
  @moduledoc """
  Simple plug to provide an unauthorized health check endpoint for use in deployments
  behind load balancers. It always responds with an empty 204 response.
  """

  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(options), do: options

  @impl true
  def call(conn, _options \\ []) do
    conn
    |> send_resp(204, "")
    |> halt()
  end
end
