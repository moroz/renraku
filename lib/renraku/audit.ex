defmodule Renraku.Audit do
  @moduledoc """
  This module contains functions necessary to audit data modifications performed
  on contact data records. At the time of this writing, it is not clear how the
  actual auditing would be implemented. Possible options include:

   * serializing events as Avro and sending to a Kafka queue,
   * serializing events as JSON and sending to a cloud logging service (CloudWatch?)
   * homebrew database-based auditing microservices (accessed over Kafka+Avro, see 1.)

  At this point, all functions in this module are no-ops with no side effects.
  """

  alias Ecto.Changeset

  alias Renraku.Contacts.Contact

  defmodule Event do
    @derive Jason.Encoder
    defstruct [:action, :case_id, :user_id, :changes, :timestamp]

    @actions [:create, :update, :delete]
    def new(action, case_id, user_id, changes \\ []) when action in @actions do
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

  def log(_event) do
    :noop
  end

  def log(action, contact, user_id, other \\ nil) do
    event = build_event(action, contact, user_id, other)
    log(event)
  end

  def build_event(:delete, %Contact{} = contact, user_id, _) do
    Event.new(:delete, contact.case_id, user_id)
  end

  def build_event(:create, %Contact{} = contact, user_id, _) do
    changes = Enum.filter(@auditable_fields, fn key -> not is_nil(Map.get(contact, key)) end)
    Event.new(:create, contact.case_id, user_id, changes)
  end

  def build_event(:update, %Contact{} = contact, user_id, %Changeset{} = changeset) do
    changes = changeset |> Map.get(:changes) |> Map.keys()

    case changes do
      [] ->
        nil

      _ ->
        Event.new(:update, contact.case_id, user_id, changes)
    end
  end
end
