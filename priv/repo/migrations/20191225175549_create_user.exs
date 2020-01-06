defmodule ApiBank.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true, size: 100
      add :name, :string
      add :password_hash, :string
      add :email, :string
      timestamps(type: :utc_datetime)
    end
    create unique_index(:users, [:email])
  end
end
