defmodule HomeVisitService.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :member_id, references(:users), null: false
      add :pal_id, references(:users), null: false
      add :visit_id, references(:visits), null: false
    end
  end
end
