defmodule Renraku.AuditTest do
  use Renraku.DataCase, async: true

  alias Renraku.Audit
  alias Renraku.Audit.Event
  alias Renraku.Contacts
  alias Renraku.Contacts.Contact

  describe "build_event/4" do
    setup do
      {:ok, %Contact{} = contact} =
        Contacts.create_contact(%{
          case_id: 42,
          first_name: "Max",
          last_name: "Mustermann",
          phone_no: "123456",
          address: "Hochallee 119",
          title: "Herr"
        })

      [contact: contact]
    end

    test "serializes create events", %{contact: contact} do
      %Event{} = actual = Audit.build_event(:create, contact, 2137, nil)
      assert actual.changes == [:address, :first_name, :last_name, :phone_no, :title]
      assert actual.action == :create
      assert actual.user_id == 2137
      assert actual.case_id == 42
    end

    test "serializes update events", %{contact: contact} do
      changeset =
        Contact.update_changeset(contact, %{
          case_id: 404,
          first_name: "Lena",
          last_name: "Baumann",
          phone_no: "456789"
        })

      %Event{} = actual = Audit.build_event(:update, contact, 2137, changeset)

      assert actual.changes == [:first_name, :last_name, :phone_no]
      assert actual.case_id == contact.case_id
      assert actual.user_id == 2137
      assert actual.action == :update
    end

    test "returns nil when nothing changes", %{contact: contact} do
      changeset =
        Contact.update_changeset(contact, %{
          first_name: "Max",
          last_name: "Mustermann"
        })

      assert changeset.changes == %{}

      refute Audit.build_event(:update, contact, 2137, changeset)
    end

    test "serializes delete events", %{contact: contact} do
      %Event{} = actual = Audit.build_event(:delete, contact, 2137, nil)
      assert actual.action == :delete
      assert actual.case_id == contact.case_id
      assert actual.user_id == 2137
    end
  end
end
