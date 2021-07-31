defmodule Renraku.Repo.Migrations.CreateCaseContacts do
  use Ecto.Migration

  def change do
    create table(:case_contacts) do
      add :case_id, :integer
      add :title, :string
      add :first_name, :string
      add :last_name, :string
      add :phone_no, :string
      add :address, :string

      timestamps()
    end

    create unique_index(:case_contacts, [:case_id])
  end
end
