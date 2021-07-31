defmodule Renraku.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:case_id, :title, :first_name, :last_name, :phone_no, :address])
    |> validate_required([:case_id, :title, :first_name, :last_name, :phone_no, :address])
    |> unique_constraint(:case_id)
  end
end
