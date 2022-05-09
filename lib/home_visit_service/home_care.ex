defmodule HomeVisitService.HomeCare do
  alias HomeVisitService.Accounts.User
  alias HomeVisitService.HomeCare.{Visit, HealthPlan}
  alias HomeVisitService.Repo

  def request_visit(%User{} = user, attrs) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> ensure_user_is_member(user)
    |> Ecto.Changeset.put_assoc(:member, user)
    |> Repo.insert()
  end

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

  defp ensure_user_is_member(changeset, user) do
    case :member in user.roles do
      true ->
        changeset

      false ->
        Ecto.Changeset.add_error(changeset, :member, "User must be a member to request a visit")
    end
  end
end
