defmodule RenrakuWeb.ContactControllerTest do
  use RenrakuWeb.ConnCase

  alias Renraku.Contacts

  @create_attrs %{address: "some address", case_id: 42, first_name: "some first_name", last_name: "some last_name", phone_no: "some phone_no", title: "some title"}
  @update_attrs %{address: "some updated address", case_id: 43, first_name: "some updated first_name", last_name: "some updated last_name", phone_no: "some updated phone_no", title: "some updated title"}
  @invalid_attrs %{address: nil, case_id: nil, first_name: nil, last_name: nil, phone_no: nil, title: nil}

  def fixture(:contact) do
    {:ok, contact} = Contacts.create_contact(@create_attrs)
    contact
  end

  describe "index" do
    test "lists all case_contacts", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Case contacts"
    end
  end

  describe "new contact" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :new))
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "create contact" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.contact_path(conn, :show, id)

      conn = get(conn, Routes.contact_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Contact"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get(conn, Routes.contact_path(conn, :edit, contact))
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "redirects when data is valid", %{conn: conn, contact: contact} do
      conn = put(conn, Routes.contact_path(conn, :update, contact), contact: @update_attrs)
      assert redirected_to(conn) == Routes.contact_path(conn, :show, contact)

      conn = get(conn, Routes.contact_path(conn, :show, contact))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      conn = put(conn, Routes.contact_path(conn, :update, contact), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete(conn, Routes.contact_path(conn, :delete, contact))
      assert redirected_to(conn) == Routes.contact_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.contact_path(conn, :show, contact))
      end
    end
  end

  defp create_contact(_) do
    contact = fixture(:contact)
    %{contact: contact}
  end
end
