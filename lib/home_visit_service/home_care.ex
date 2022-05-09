defmodule HomeVisitService.HomeCare do
  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.{Visit, HealthPlan}
  alias HomeVisitService.Repo

  def request_visit(%User{} = user, attrs) do
    %Visit{}
    |> Visit.changeset(user, attrs)
    |> Ecto.Changeset.put_assoc(:member, user)
    |> Repo.insert()
  end

  def get_all_visits(), do: Repo.all(Visit)

  def create_default_plans() do
    [
      %{
        minutes: 43800,
        price: 0.35,
        plan_type: "basic"
      },
      %{
        minutes: 43800 * 3,
        price: 0.28,
        plan_type: "immediate"
      },
      %{
        minutes: 43800 * 6,
        price: 0.22,
        plan_type: "advance"
      }
    ]
    |> then(
      &Repo.insert_all(HealthPlan, &1, on_conflict: :replace_all, conflict_target: :plan_type)
    )
  end

  def get_supported_health_plans(), do: Repo.all(HealthPlan)
end
