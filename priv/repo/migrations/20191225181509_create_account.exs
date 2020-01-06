defmodule ApiBank.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add :id, :string, primary_key: true, size: 100
      add :user_id, references(:users, type: :"CHAR(32)")
      add :value, :integer
      timestamps(type: :utc_datetime)
    end
  end
end
