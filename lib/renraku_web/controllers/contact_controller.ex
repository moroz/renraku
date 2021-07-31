defmodule RenrakuWeb.ContactController do
  use RenrakuWeb, :controller

  alias Renraku.Contacts
  alias Renraku.Audit
  alias Renraku.Contacts.Contact

  def get_user_id(conn), do: conn.assigns[:user_id]

  def new(conn, %{"case_id" => case_id}) do
    changeset = Contacts.change_contact(%Contact{case_id: case_id})

    conn
    |> assign(:case_id, case_id)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"contact" => contact_params}) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        user_id = get_user_id(conn)
        Audit.log(:create, contact, user_id)

        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        case_id = Ecto.Changeset.get_change(changeset, :case_id)
        render(conn, "new.html", changeset: changeset, case_id: case_id)
    end
  end

  def show(conn, %{"case_id" => case_id}) do
    case Contacts.get_contact_by_case_id(case_id) do
      nil ->
        conn
        |> put_status(404)
        |> assign(:case_id, case_id)
        |> render("not_found.html")

      %Contact{} = contact ->
        render(conn, "show.html", contact: contact)
    end
  end

  def edit(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    changeset = Contacts.change_contact(contact)

    conn
    |> assign(:case_id, case_id)
    |> assign(:changeset, changeset)
    |> assign(:contact, contact)
    |> render("edit.html")
  end

  def update(conn, %{"case_id" => case_id, "contact" => contact_params}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    changeset = Contact.update_changeset(contact, contact_params)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, contact} ->
        user_id = get_user_id(conn)
        Audit.log(:update, contact, user_id, changeset)

        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact: contact, changeset: changeset)
    end
  end

  def confirm_delete(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)

    conn
    |> assign(:contact, contact)
    |> render("confirm_delete.html")
  end

  def delete(conn, %{"case_id" => case_id}) do
    contact = Contacts.get_contact_by_case_id!(case_id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    user_id = get_user_id(conn)
    Audit.log(:delete, contact, user_id)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: Routes.contact_path(conn, :show, case_id))
  end
end
