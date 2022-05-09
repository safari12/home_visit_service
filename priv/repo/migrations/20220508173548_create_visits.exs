defmodule HomeVisitService.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits) do
      add :date, :date
      add :minutes, :integer
      add :tasks, {:array, :string}
      add :status, :string
      add :member_id, references(:users), null: false
    end

    create index(:visits, [:member_id])
  end
end
