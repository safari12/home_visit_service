defmodule HomeVisitService.Repo.Migrations.CreateHealthPlans do
  use Ecto.Migration

  def change do
    create table(:health_plans, primary_key: false) do
      add :plan_type, :string, primary_key: true
      add :minutes, :integer, null: false
      add :price, :float, null: false
    end
  end
end
