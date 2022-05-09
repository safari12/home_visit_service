defmodule HomeVisitService.HomeCare.HealthPlan do
  use Ecto.Schema

  @primary_key {:plan_type, :string, []}
  schema "health_plans" do
    field :minutes, :integer
    field :price, :float
  end
end
