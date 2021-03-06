defmodule HomeVisitService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :remaining_minutes, :integer

      add :health_plan_id, references(:health_plans, column: :plan_type, type: :string)

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
