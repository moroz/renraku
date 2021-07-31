defmodule Renraku.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(case_id)a
  @cast @required ++ ~w(title first_name last_name phone_no address)a
  @update_cast @cast -- [:case_id]

  @derive {Phoenix.Param, key: :case_id}
  schema "case_contacts" do
    field :address, :string
    field :case_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :phone_no, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> unique_constraint(:case_id)
  end

  @doc false
  def update_changeset(contact, attrs) do
    contact
    |> cast(attrs, @update_cast)
  end
end
