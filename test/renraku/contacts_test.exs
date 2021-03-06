defmodule Renraku.ContactsTest do
  use Renraku.DataCase

  alias Renraku.Contacts

  describe "case_contacts" do
    alias Renraku.Contacts.Contact

    @valid_attrs %{
      address: "some address",
      case_id: 42,
      first_name: "some first_name",
      last_name: "some last_name",
      phone_no: "some phone_no",
      title: "some title"
    }
    @update_attrs %{
      address: "some updated address",
      case_id: 43,
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      phone_no: "some updated phone_no",
      title: "some updated title"
    }
    @invalid_attrs %{
      address: nil,
      case_id: nil,
      first_name: nil,
      last_name: nil,
      phone_no: nil,
      title: nil
    }

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contacts.create_contact()

      contact
    end

    test "list_case_contacts/0 returns all case_contacts" do
      contact = contact_fixture()
      assert Contacts.list_case_contacts() == [contact]
    end

    test "get_contact_by_case_id!/1 returns the contact with given case_id" do
      contact = contact_fixture()
      assert Contacts.get_contact_by_case_id!(contact.case_id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Contacts.create_contact(@valid_attrs)
      assert contact.address == "some address"
      assert contact.case_id == 42
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.phone_no == "some phone_no"
      assert contact.title == "some title"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = updated} = Contacts.update_contact(contact, @update_attrs)

      # Case id cannot be updated
      assert updated.case_id == contact.case_id

      assert updated.address == "some updated address"
      assert updated.first_name == "some updated first_name"
      assert updated.last_name == "some updated last_name"
      assert updated.phone_no == "some updated phone_no"
      assert updated.title == "some updated title"
    end

    test "update_contact/2 with empty fields clears all fields" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = updated} = Contacts.update_contact(contact, @invalid_attrs)

      assert updated.case_id == contact.case_id

      for field <- ~w(address first_name last_name phone_no title)a do
        refute Map.get(updated, field)
      end
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)

      assert_raise Ecto.NoResultsError, fn ->
        Contacts.get_contact_by_case_id!(contact.case_id)
      end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end
end
