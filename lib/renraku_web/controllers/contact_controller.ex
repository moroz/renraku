defmodule RenrakuWeb.ContactController do
  use RenrakuWeb, :controller

  alias Renraku.Contacts
  alias Renraku.Contacts.Contact

  def index(conn, _params) do
    case_contacts = Contacts.list_case_contacts()
    render(conn, "index.html", case_contacts: case_contacts)
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contact" => contact_params}) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    render(conn, "show.html", contact: contact)
  end

  def edit(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    changeset = Contacts.change_contact(contact)
    render(conn, "edit.html", contact: contact, changeset: changeset)
  end

  def update(conn, %{"case_id" => case_id, "contact" => contact_params}) do
    contact = Contacts.get_contact_by_case_id!(case_id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: Routes.contact_path(conn, :index))
  end
end
