defmodule Renraku.Token do
  @moduledoc """
  This module contains utility functions necessary to decode and verify JWT tokens
  passed from the client. This module does not allow encoding tokens as the application
  does not possess the private key necessary to sign tokens.

  ## Examples

      iex> jwt = File.read!("priv/test_jwt")
      iex> Renraku.Token.verify_and_validate(jwt)
      {:ok, %{} = payload}

  """

  use Joken.Config

  def token_config do
    %{}
    |> add_claim("iss", "parc-cli")
  end
end
