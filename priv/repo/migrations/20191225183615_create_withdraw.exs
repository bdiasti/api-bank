defmodule ApiBank.Repo.Migrations.CreateWithdraw do
  use Ecto.Migration

  def change do
    create table(:withdraw, primary_key: false) do
      add :id, :string, primary_key: true, size: 100
      add :account_id, references(:account, type: :"CHAR(32)")
      add :value, :integer
      timestamps(type: :utc_datetime)
    end
  end
end
