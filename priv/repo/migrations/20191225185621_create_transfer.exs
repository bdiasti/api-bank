defmodule ApiBank.Repo.Migrations.CreateTransfer do
  use Ecto.Migration

  def change do
    create table(:transfer,primary_key: false) do
      add :id, :string, primary_key: true, size: 100
      add :account_source, references(:account,type: :"CHAR(32)")
      add :account_destination, references(:account,type: :"CHAR(32)")
      add :value, :integer
      timestamps(type: :utc_datetime)
    end
  end
end
