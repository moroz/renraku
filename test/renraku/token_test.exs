defmodule Renraku.TokenTest do
  use Renraku.DataCase, async: true
  alias Renraku.Token

  @jwt File.read!("priv/test_jwt") |> String.trim()

  describe "verify_and_validate/1" do
    test "returns {:ok, payload} for valid token" do
      assert {:ok, payload} = Token.verify_and_validate(@jwt)

      now = :os.system_time(:second)
      assert payload["exp"] > now
    end
  end
end
