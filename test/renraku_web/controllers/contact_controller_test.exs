defmodule RenrakuWeb.ContactControllerTest do
  use RenrakuWeb.ConnCase

  alias Renraku.Contacts

  @jwt String.trim(File.read!("priv/test_jwt"))

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", @jwt)

    [conn: conn]
  end

  @create_attrs %{
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

  def fixture(:contact) do
    {:ok, contact} = Contacts.create_contact(@create_attrs)
    contact
  end

  describe "new contact" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :new, case_id: 42))
      assert html_response(conn, 200) =~ ~r/contact data for case #42/i
    end
  end

  describe "create contact" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @create_attrs)

      assert %{case_id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.contact_path(conn, :show, id)

      conn = get(conn, Routes.contact_path(conn, :show, id))
      assert html_response(conn, 200) =~ ~r/contact data for case #42/i
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get(conn, Routes.contact_path(conn, :edit, contact))
      assert html_response(conn, 200) =~ ~r/contact data for case #42/i
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
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete(conn, Routes.contact_path(conn, :delete, contact))
      assert redirected_to(conn) == Routes.contact_path(conn, :show, contact.case_id)

      refetch = get(conn, Routes.contact_path(conn, :show, contact))
      assert html_response(refetch, 404)
    end
  end

  defp create_contact(_) do
    contact = fixture(:contact)
    %{contact: contact}
  end
end
