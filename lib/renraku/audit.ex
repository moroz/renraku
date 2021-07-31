defmodule Renraku.Audit do
  alias Ecto.Changeset

  alias Renraku.Contacts.Contact

  defmodule Event do
    @derive Jason.Encoder
    defstruct [:action, :case_id, :user_id, :changes, :timestamp]

    @actions [:create, :update, :delete]
    def new(action, case_id, user_id, changes) when action in @actions do
      %__MODULE__{
        action: action,
        case_id: case_id,
        user_id: user_id,
        changes: changes,
        timestamp: :os.system_time(:second)
      }
    end
  end

  @auditable_fields ~w(address first_name last_name phone_no title)a

  def log(:delete, %Contact{} = contact, user_id) do
    do_log(:delete, contact.case_id, user_id)
  end

  def log(:create, %Contact{} = contact, user_id) do
    changes = Enum.filter(@auditable_fields, fn key -> not is_nil(Map.get(contact, key)) end)
    do_log(:create, contact.case_id, user_id, changes)
  end

  def log(:update, %Contact{} = contact, user_id, %Changeset{} = changeset) do
    changes = changeset |> Map.get(:changes) |> Map.keys()

    case changes do
      [] ->
        :noop

      _ ->
        do_log(:update, contact.case_id, user_id, changes)
    end
  end

  defp do_log(action, case_id, user_id, changes \\ []) do
    Event.new(action, case_id, user_id, changes)
  end
end
